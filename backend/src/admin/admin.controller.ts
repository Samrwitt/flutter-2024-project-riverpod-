import { Controller, Get,HttpCode, HttpStatus, Post, Body, Req, Param, Delete, UseGuards, Res, BadRequestException, UnauthorizedException, Header } from '@nestjs/common';
import { AdminService } from './admin.service';
import { Role } from 'src/roles/role.enum';
import { Roles } from 'src/roles/roles.decorator';
import { JwtAuthGuard } from 'src/auth/auth.guard';
import { RolesGuard } from 'src/roles/roles.guard';
import { AuthService } from 'src/auth/auth.service';
import { LoginDto } from './dto/login-admin.dto';
import { LoginUserDto } from 'src/users/dto/login-users.dto';
import { User } from 'src/users/schemas/user.schema';

@Controller('admin')
export class AdminController {
  constructor(private readonly adminService: AdminService,
    private readonly authService: AuthService,
    
  ) {}
 

  @Roles(Role.Admin)
  @UseGuards(JwtAuthGuard,RolesGuard)
  @Get('users')
  async getAllUsers(): Promise<User[]> {
    return this.adminService.getAllUsers();
  }

  @HttpCode(HttpStatus.OK)
  @Post('login')
  async login(@Body() loginDto: LoginDto, @Req() request, @Res() response) {
    try {
      const {access_token, user } = await this.adminService.login(loginDto);
      // Set the token in the response header or cookie
      response.setHeader('Authorization', `Bearer ${access_token}`);
      response.status(HttpStatus.OK).json({ access_token, user });
    } catch (error) {
      // Handle errors
      response.status(HttpStatus.UNAUTHORIZED).json({ message: error.message });
    }
  }
  // @Post('admin/login')
  // async adminLogin(@Body() loginUserDto: LoginUserDto, @Res({ passthrough: true }) response: Response): Promise<{ userId: string; token: string }> {
  //     try {
  //         const { access_token, user } = await this.AdminService.login(loginUserDto.email, loginUserDto.password);
  
  //         if (!access_token || !user) {
  //             throw new UnauthorizedException('Invalid credentials');
  //         }
  
  //         response.cookie('jwt', access_token, { httpOnly: true });
  
  //         return { userId: user.id, token: access_token };
  //     } catch (error) {
  //         console.log(error);
  //         throw new UnauthorizedException('Invalid credentials');
  //     }
  // }
  


  @Roles(Role.Admin)
  @UseGuards(JwtAuthGuard,RolesGuard)
  // @Get('allwithnotes')
  // getAllUsers() {
  //   return this.adminService.getAllUsersWithNotes();
  // }

  @Roles(Role.Admin)
  @UseGuards(JwtAuthGuard,RolesGuard)
  @Delete('note/:id')
  deleteNote(@Param('id') id: string) {
    console.log('delete note in');
    return this.adminService.deleteNote(id);
  }

  @Roles(Role.Admin)
  @UseGuards(JwtAuthGuard,RolesGuard)
  @Delete('user/:id')
  deleteUser(@Param('id') id: string) {
    console.log('delete user');
    return this.adminService.deleteUserAndNotes(id);
  }

  // @UseGuards(JwtAuthGuard)
  // @Post('logout')
  // @HttpCode(HttpStatus.OK)
  // async logout(@Req() req: Request) {
  //   const authHeader = req.headers('authorization');
  //   if (!authHeader) {
  //     throw new UnauthorizedException('Authorization header not found');
  //   }
  //   const token = authHeader.split(' ')[1];
  //   await this.authService.logout(token);
  //   return { message: 'Successfully logged out' };
  // }

}
