import { IsEmail, IsNotEmpty, IsOptional, IsString, MinLength } from "class-validator";

export class CreateUsersDto {

    @IsOptional()
    @IsNotEmpty()
    @IsString()
    username?: string;
  
    @IsOptional()
    @IsNotEmpty()
    @IsString()
    @MinLength(8)
    password?: string;
  
    @IsOptional()
    @IsNotEmpty()
    @IsEmail()
    email?: string;
  
    @IsOptional()
    @IsNotEmpty()
    @IsString()
    role?: string;
}
