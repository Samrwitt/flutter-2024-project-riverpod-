import { PartialType } from '@nestjs/mapped-types';
import { CreateLogDto } from './create-logs.dto';

export class UpdateLogDto extends PartialType(CreateLogDto) {}
