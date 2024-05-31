import { Injectable, UnauthorizedException, NotFoundException } from '@nestjs/common';
import { Log, LogsDocument } from './schemas/log.schema';
import { Model } from 'mongoose';
import { InjectModel } from '@nestjs/mongoose';
import { CreateLogDto } from './dto/create-logs.dto';
import { UpdateLogDto } from './dto/update-logs.dto';
import { Role } from 'src/roles/role.enum'; // Adjust path as per your project structure

@Injectable()
export class LogsService {
  constructor(@InjectModel(Log.name) private readonly logModel: Model<LogsDocument>) {}

  async create(createLogDto: CreateLogDto, userRole: string): Promise<Log> {
    if (userRole !== Role.Admin) {
      throw new UnauthorizedException('Only admins can create logs.');
    }
    try {
      const createdLog = new this.logModel(createLogDto);
      await createdLog.save();
      // Retrieve the full document after saving
      const fullLog = await this.logModel.findById(createdLog._id).exec();
      console.log('Created log with ID:', fullLog._id); // Additional logging
      return fullLog;
    } catch (error) {
      console.error('Error creating log:', error); // Improved logging to include full error
      throw new Error('Unable to create log');
    }
  }

  async remove(id: string, userRole: string): Promise<Log> {
    if (userRole !== Role.Admin) {
      throw new UnauthorizedException('Only admins can delete logs.');
    }
    const deletedLog = await this.logModel.findOneAndDelete({ _id: id }).exec();
    if (!deletedLog) {
      throw new NotFoundException('Log not found');
    }
    return deletedLog;
  }

  async findById(id: string): Promise<Log> {
    const log = await this.logModel.findById(id).exec();
    if (!log) {
      throw new NotFoundException('Log not found');
    }
    return log;
  }

  async findAll(): Promise<Log[]> {
    return this.logModel.find().exec();
  }

  async update(id: string, updateLogDto: UpdateLogDto, userRole: string): Promise<Log> {
    if (userRole !== Role.Admin) {
      throw new UnauthorizedException('Only admins can update logs.');
    }
    const updatedLog = await this.logModel
      .findOneAndUpdate({ _id: id }, { $set: updateLogDto, updatedAt: new Date() }, { new: true })
      .exec();
    if (!updatedLog) {
      throw new NotFoundException('Log not found');
    }
    return updatedLog;
  }
}