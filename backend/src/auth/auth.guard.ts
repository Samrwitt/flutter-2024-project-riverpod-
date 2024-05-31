import { CanActivate, ExecutionContext, Injectable, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { UsersService } from 'src/users/users.service'; // Adjust path as per your project structure
import { AuthService } from 'src/auth/auth.service'; // Ensure correct path
import { jwtConstants } from 'src/auth/constants'; // Adjust path as per your project structure

@Injectable()
export class JwtAuthGuard implements CanActivate {
  constructor(
    private readonly jwtService: JwtService,
    private readonly usersService: UsersService,
    private readonly authService: AuthService, // Add this line
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request = context.switchToHttp().getRequest();

    if (!request.headers.authorization) {
      console.log('Authorization header not found');
      throw new UnauthorizedException('Authorization header not found');
    }

    const token = request.headers.authorization.split(' ')[1];
    console.log('Received Token:', token);

    // Check if the token is blacklisted
    if (this.authService.isTokenBlacklisted(token)) {
      console.log('Token is blacklisted');
      throw new UnauthorizedException('Token is blacklisted');
    }

    try {
      const payload = await this.jwtService.verifyAsync(token, {
        secret: jwtConstants.secret,
      });
      console.log('JWT Payload:', payload);

      // Retrieve user from the database using the id from JWT payload
      const user = await this.usersService.findOne(payload.id);
      if (!user) {
        console.log('User not found for id:', payload.id);
        throw new UnauthorizedException('User not found');
      }

      // Attach user object to the request for downstream use
      request.user = user;

      return true;
    } catch (e) {
      console.log('Error verifying JWT token:', e.message);
      throw new UnauthorizedException('Unauthorized');
    }
  }
}