import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import * as cookieParser from 'cookie-parser';
import { UsersService } from './users/users.service';
import { Role } from './roles/role.enum';
const port= 3000;

async function bootstrap() {
  const app = await NestFactory.create(AppModule,{cors:true});
  // app.enableCors(options:{
  //   origin:'http://localhost:5001',
  //   Credential:true
  // })
  await app.use(cookieParser());
  const userService= app.get(UsersService);
  const admins= await userService.findAdminUsers();
  if (admins.length ===0){
    const admin1= {
      username:"admin",
      email:"'admin@gmail.com",
      password:"adminadmin",
      role:Role.Admin,
  };
  // const admin2 ={
  //     username:"admintwo",
  //     email:"admintwo@gmail.com",
  //     password:"adminadmin",
  //     role:Role.Admin,
  // }
  await userService.createAdmin(admin1);
  // await userService.createAdmin(admin2);
  }
  
  await app.listen(3000);

}
bootstrap();