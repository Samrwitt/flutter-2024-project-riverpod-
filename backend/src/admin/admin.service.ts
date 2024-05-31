import { Injectable, NotFoundException, UnauthorizedException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model, Types } from 'mongoose';
import * as bcrypt from 'bcrypt';
import { JwtService } from '@nestjs/jwt';
import { Note, NoteDocument } from 'src/notes/schemas/note.schema';
import { User, UserDocument } from 'src/users/schemas/user.schema';
import { UsersService } from 'src/users/users.service';
import { LoginDto } from 'src/admin/dto/login-admin.dto';
import { ConfigService } from '@nestjs/config';
import { Role } from 'src/roles/role.enum';
import { AuthService } from 'src/auth/auth.service'; // Ensure correct path

@Injectable()
export class AdminService {
  private readonly adminEmail: string;
  private readonly adminPasswordHash: string;

  constructor(
    @InjectModel(Note.name) private readonly noteModel: Model<NoteDocument>,
    private readonly usersService: UsersService,
    private jwtService: JwtService,
    private readonly authService: AuthService,
    @InjectModel(User.name) private readonly userModel: Model<UserDocument>,
    private readonly configService: ConfigService,
  ) {
    this.adminEmail = this.configService.get<string>('ADMIN_EMAIL');
    this.adminPasswordHash = this.configService.get<string>('ADMIN_PASSWORD_HASH');
    this.initializeAdmins(); // Initialize admins on service creation
  }

  async getAllUsers(): Promise<User[]> {
    return this.userModel.find().exec();
  }

  async initializeAdmins() {
    const admins = await this.usersService.findAdminUsers();
    if (admins.length === 0) {
      const initialAdmins = [
        {
          username: 'admin',
          email: this.adminEmail,
          password: this.adminPasswordHash,
          role: Role.Admin,
        },
      ];
      for (const adminData of initialAdmins) {
        await this.createAdmin(adminData);
      }
      console.log('Initial admin users created');
    }
  }

  async createAdmin(adminData: { username: string; email: string; password: string; role: Role; }) {
    const hashedPassword = await bcrypt.hash(adminData.password, 10);
    const admin = new this.userModel({ ...adminData, password: hashedPassword });
    return admin.save();
  }

  async getAllUsersWithNotes(): Promise<{ [userId: string]: Note[] }> {
    const allUsers = await this.usersService.findAll() as UserDocument[];
    const result: { [userId: string]: Note[] } = {};

    for (const user of allUsers) {
      const userId = user.id; // TypeScript now knows that user has an id property
      const userNotes = await this.noteModel.find({ userId: new Types.ObjectId(userId) }).exec();
      result[userId] = userNotes;
    }

    return result;
  }

  async deleteUserAndNotes(userId: string): Promise<void> {
    const objectId = new Types.ObjectId(userId);
    const user = await this.userModel.findById(objectId);
    if (!user) {
      throw new NotFoundException('User not found');
    }

    await this.noteModel.deleteMany({ userId: objectId }).exec();
    await this.userModel.findByIdAndDelete(objectId).exec();

    console.log('Successfully deleted user and user data');
  }

  async deleteNote(noteId: string): Promise<boolean> {
    const objectId = new Types.ObjectId(noteId);
    const deletedNote = await this.noteModel.findByIdAndDelete(objectId).exec();
    if (!deletedNote) {
      throw new NotFoundException('Note not found');
    }
    return true;
  }

  async findAdminUsers(): Promise<User[]> {
    return this.userModel.find({ role: Role.Admin }).exec();
  }

  async login(loginDto: LoginDto): Promise<{ access_token: string; user: User }> {
    const { email, password } = loginDto;

    const admin = await this.authService.validateUser(email, password);
    if (!admin || admin.role !== Role.Admin) {
      throw new UnauthorizedException('Invalid email or role');
    }

    const access_token = await this.authService.generateJwtToken(admin);
    if (!access_token) {
      console.error('JWT Token generation failed');
      throw new UnauthorizedException('Token generation failed');
    }
    console.log('Admin logged in successfully, Token:', access_token);

    return { access_token, user: admin };
  }
}
