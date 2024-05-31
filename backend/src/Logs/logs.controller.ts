import { Body, Controller, Delete, Get, Param, Patch, Post, Req, UseGuards, Res, HttpStatus } from '@nestjs/common';
import { LogsService } from './logs.service';
import { CreateLogDto } from './dto/create-logs.dto';
import { UpdateLogDto } from './dto/update-logs.dto';
import { JwtAuthGuard } from 'src/auth/auth.guard';

@Controller('logs')
export class LogsController {
  constructor(private readonly logsService: LogsService) {}

  @UseGuards(JwtAuthGuard)
  @Post()
  async create(@Body() createLogDto: CreateLogDto, @Req() req: any, @Res() res: any) {
    try {
      const createdLog = await this.logsService.create(createLogDto, req.user.role);
      return res.status(HttpStatus.CREATED).json(createdLog);
    } catch (error) {
      console.error('Error creating log:', error.message); // Additional logging
      return res.status(HttpStatus.INTERNAL_SERVER_ERROR).json({
        message: error.message,
      });
    }
  }

  @UseGuards(JwtAuthGuard)
  @Delete(':id')
  async remove(@Param('id') id: string, @Req() req: any, @Res() res: any) {
    try {
      const deletedLog = await this.logsService.remove(id, req.user.role);
      return res.status(HttpStatus.OK).json(deletedLog);
    } catch (error) {
      console.error('Error deleting log:', error.message); // Additional logging
      return res.status(HttpStatus.INTERNAL_SERVER_ERROR).json({
        message: error.message,
      });
    }
  }

  @UseGuards(JwtAuthGuard)
  @Get(':id')
  async findById(@Param('id') id: string, @Res() res: any) {
    try {
      const log = await this.logsService.findById(id);
      return res.status(HttpStatus.OK).json(log);
    } catch (error) {
      console.error('Error finding log:', error.message); // Additional logging
      return res.status(HttpStatus.INTERNAL_SERVER_ERROR).json({
        message: error.message,
      });
    }
  }

  @UseGuards(JwtAuthGuard)
  @Get()
  async findAll(@Res() res: any) {
    try {
      const logs = await this.logsService.findAll();
      return res.status(HttpStatus.OK).json(logs);
    } catch (error) {
      console.error('Error finding logs:', error.message); // Additional logging
      return res.status(HttpStatus.INTERNAL_SERVER_ERROR).json({
        message: error.message,
      });
    }
  }

  @UseGuards(JwtAuthGuard)
  @Patch(':id')
  async update(@Body() updateLogDto: UpdateLogDto, @Param('id') id: string, @Req() req: any, @Res() res: any) {
    try {
      const updatedLog = await this.logsService.update(id, updateLogDto, req.user.role);
      return res.status(HttpStatus.OK).json(updatedLog);
    } catch (error) {
      console.error('Error updating log:', error.message); // Additional logging
      return res.status(HttpStatus.INTERNAL_SERVER_ERROR).json({
        message: error.message,
      });
    }
  }
}