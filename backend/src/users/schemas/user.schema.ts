import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document, Types } from 'mongoose';
import { Role } from 'src/roles/role.enum';

@Schema()
export class User {
  @Prop({ type: Types.ObjectId })
  id: Types.ObjectId;

  @Prop({ required: true })
  username: string;

  @Prop({ required: true, unique: true })
  email: string;

  @Prop({ required: true })
  password: string;

  @Prop({ required: true, enum: Role })
  role: Role;
}

export type UserDocument = User & Document;
export const UserSchema = SchemaFactory.createForClass(User);