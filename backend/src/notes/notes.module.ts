import { Module } from '@nestjs/common';
import { NotesController } from './notes.controller';
import { NotesService } from './notes.service';
import { MongooseModule } from '@nestjs/mongoose';
import { Note, NoteSchema } from './schemas/note.schema';
import { AuthService } from 'src/auth/auth.service';
import { UsersService } from 'src/users/users.service';
import { UsersModule } from 'src/users/schemas/user.module';
import { User, UserSchema } from 'src/users/schemas/user.schema';

@Module({
  imports:[MongooseModule.forFeature([{name:Note.name,schema:NoteSchema}]),
  MongooseModule.forFeature([{name:User.name,schema:UserSchema}])],
  controllers: [NotesController],
  providers: [NotesService,AuthService,UsersService,UsersModule],
  exports:[],
})
export class NotesModule {}
