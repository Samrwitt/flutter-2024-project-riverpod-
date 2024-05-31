import { IsNotEmpty } from "class-validator";


export class CreateNotesDto {
    @IsNotEmpty()
    title:string;

    @IsNotEmpty()
    content:string;

    @IsNotEmpty()
    userId:string;

    @IsNotEmpty()
    index:number;

     @IsNotEmpty()
     notesid:string;

}
