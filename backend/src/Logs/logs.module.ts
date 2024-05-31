import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { LogsController } from './logs.controller';
import { LogsService } from './logs.service';
import { Log, LogSchema } from './schemas/log.schema';
import { JwtAuthGuard } from '../auth/auth.guard'; // Import JwtAuthGuard
import { AuthService } from '../auth/auth.service'; // Import AuthService
import { UsersService } from 'src/users/users.service';
import { User, UserSchema } from '../users/schemas/user.schema';
import { RolesGuard } from 'src/roles/roles.guard';
import {  createMongooseOptions } from 'database.config';

@Module({
  imports: [
    MongooseModule.forFeature([{ name: Log.name, schema: LogSchema }]),
    MongooseModule.forFeature([{name:User.name,schema:UserSchema}])],
    // MongooseModule.forRootAsync({
    //     useFactory: createMongooseOptions,
    //   }),
  // ],
  controllers: [LogsController],
  providers: [
    LogsService,
    JwtAuthGuard, // Add JwtAuthGuard to the providers
    AuthService, // Add AuthService to the providers
    UsersService, RolesGuard
],
  exports: [LogsService], // Export if needed by other modules
})
export class LogsModule {}
