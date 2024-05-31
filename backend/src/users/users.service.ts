import { BadRequestException, ConflictException, Injectable, NotFoundException } from '@nestjs/common';
import { CreateUsersDto } from './dto/create-users.dto';
import { UpdateUsersDto } from './dto/update-users.dto';
import { LoginUserDto } from './dto/login-users.dto';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { User, UserDocument } from './schemas/user.schema';
import * as bcrypt from 'bcrypt';
import { Role } from 'src/roles/role.enum';

@Injectable()
export class UsersService {

  constructor(@InjectModel(User.name) private readonly userModel: Model<UserDocument>) {}

   

  async register(createUserDto: CreateUsersDto): Promise<User> {
    const existingUser = await this.userModel.findOne({ email: createUserDto.email }).exec();
    if (existingUser) {
      throw new ConflictException('Email already exists');
    }

    const hashedPassword = await bcrypt.hash(createUserDto.password, 10);
    const createdUser = new this.userModel({ ...createUserDto, role: Role.User, password: hashedPassword });
    return createdUser.save();
  }

  async findAll(): Promise<User[]> {
    return this.userModel.find().exec();
  }

  async profile(userId: string): Promise<User> {
    const user = await this.userModel.findById(userId).exec();
    if (!user) {
      throw new NotFoundException('User not found');
    }
    return user;
  }

  async updateProfile(userId: string, updateUserDto: UpdateUsersDto): Promise<User> {
    const updatedUser = await this.userModel
      .findOneAndUpdate({ _id: userId }, { $set: updateUserDto }, { new: true })
      .exec();

    if (!updatedUser) {
      throw new NotFoundException('User not found');
    }
    return updatedUser;
  }

  async deleteAccount(userId: string): Promise<User> {
    const deletedUser = await this.userModel.findOneAndDelete({ _id: userId }).exec();
    if (!deletedUser) {
      throw new NotFoundException('User not found');
    }
    return deletedUser;
  }

  async findByEmail(email: string): Promise<User | null> {
    return this.userModel.findOne({ email }).exec();
  }

  async findAdminUsers(): Promise<User[]> {
    return this.userModel.find({ role: Role.Admin }).exec();
  }

  async createAdmin(adminData: { username: string; email: string; password: string }): Promise<User> {
    const existingAdmin = await this.userModel.findOne({ email: adminData.email }).exec();
    if (existingAdmin) {
      throw new ConflictException('Admin with this email already exists');
    }

    const hashedPassword = await bcrypt.hash(adminData.password, 10);
    const admin = new this.userModel({ ...adminData, role: Role.Admin, password: hashedPassword });
    return admin.save();
  }

  async findOne(id: string): Promise<User | undefined> {
    const user = await this.userModel.findById(id).exec();
    if (!user) {
      throw new BadRequestException('User not found');
    }
    return user;
  }
}
