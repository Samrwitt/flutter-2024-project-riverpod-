import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document, Types } from 'mongoose';
import { User } from '../../users/schemas/user.schema';

@Schema()
export class Log{
  
    @Prop({ required: true, maxlength: 100 })
  name: string; 

//   @Prop({ required: true, maxlength: 255 })
//   content: string; 
//type: Types.ObjectId, ref: 'User',
  @Prop({  required: true })
  user: string; 

  @Prop({ required: true })
  date: string; 

  @Prop({ required: true })
  time: string; 

  @Prop([String])
 logs: string[];

//  @Prop()
//     logsid:String;

}

export type LogsDocument = Log & Document;
export const LogSchema = SchemaFactory.createForClass(Log);
