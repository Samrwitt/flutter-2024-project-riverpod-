import { Prop, Schema, SchemaFactory } from "@nestjs/mongoose";
import { Document, Types } from "mongoose";
import { Role } from "src/roles/role.enum";

export type UserDocument = User & Document;

@Schema({ timestamps: true }) // This will automatically add createdAt and updatedAt fields
export class User {
    @Prop({ required: true, unique: true })
    email: string;

    @Prop({ required: true })
    username: string;

    @Prop({ required: true })
    password: string;

    @Prop()
    role: Role;

    _id: Types.ObjectId;
}

export const UserSchema = SchemaFactory.createForClass(User);
