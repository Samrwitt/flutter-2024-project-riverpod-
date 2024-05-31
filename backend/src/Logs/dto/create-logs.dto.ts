import { IsNotEmpty, IsString, MaxLength } from 'class-validator';

export class CreateLogDto {
    @IsNotEmpty()
    @IsString()
    @MaxLength(100)
     name: string;

    @IsNotEmpty()
     user: string;

    @IsNotEmpty()
     date: string;

    @IsNotEmpty()
     time: string;

    @IsNotEmpty()
     logs: string[];

    //  @IsNotEmpty()
    // logsId:string;
}
