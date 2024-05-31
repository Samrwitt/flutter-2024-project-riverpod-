import { IsEmail, IsNotEmpty } from "class-validator";

export class LoginUserDto{
    @IsNotEmpty()
    @IsEmail()
    email:string;

    username:string;

    @IsNotEmpty()
    password:string;

    role:string;
}