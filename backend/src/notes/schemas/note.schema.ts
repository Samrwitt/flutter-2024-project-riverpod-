import { Prop, Schema, SchemaFactory } from "@nestjs/mongoose";
import {  Document, Types } from "mongoose";


// export type noteDocument =HydratedDocument<note>;


@Schema()
export class Note{
    @Prop({required:true})
    title:string

    @Prop({required:true})
    content:string;

    @Prop({ref:'User', required:true})
    userId:string;

    //Time stamps
    @Prop({default:Date.now})
    createdAt:Date;

    @Prop({default:Date.now})
    updatedAt:Date;

    @Prop({ type: Types.ObjectId })
    notesid:Types.ObjectId;

    @Prop( {required: true})
    index:number;   
}
export type NoteDocument = Note & Document;
export const NoteSchema =SchemaFactory.createForClass(Note);

