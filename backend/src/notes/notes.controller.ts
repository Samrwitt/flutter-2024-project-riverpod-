import { Body, Res, Controller, HttpStatus, Headers, Delete, Get, Param, Patch, Post, Req, UseGuards } from '@nestjs/common';
import { NotesService } from './notes.service';
import { Response } from 'express';
import { CreateNotesDto } from './dto/create-notes.dto';
import { UpdateNotesDto } from './dto/update-notes.dto';
import { JwtAuthGuard } from 'src/auth/auth.guard';

@Controller('notes')
export class NotesController {
    constructor(private readonly notesService: NotesService) {}

    @UseGuards(JwtAuthGuard)
    @Post()
    async create(@Body() createNoteDto: CreateNotesDto, @Headers() headers: any, @Res() res: Response) {
        try {
            const userId = headers['user-id'];
            if (!userId) {
                return res.status(HttpStatus.BAD_REQUEST).json({ message: 'User ID is required' });
            }
            const createdNote = await this.notesService.create(createNoteDto, userId);
            return res.status(HttpStatus.CREATED).json(createdNote);
        } catch (error) {
            return res.status(HttpStatus.INTERNAL_SERVER_ERROR).json({
                message: 'Failed to create note',
                error: error.message,
            });
        }
    }

    @UseGuards(JwtAuthGuard)
    @Delete(':id')
    async remove(@Param('id') id: string, @Headers() headers: any, @Res() res: Response) {
        try {
            const userId = headers['user-id'];
            if (!userId) {
                return res.status(HttpStatus.BAD_REQUEST).json({ message: 'User ID is required' });
            }
            const deletedNote = await this.notesService.remove(id, userId);
            return res.status(HttpStatus.OK).json(deletedNote);
        } catch (error) {
            return res.status(HttpStatus.INTERNAL_SERVER_ERROR).json({
                message: 'Failed to delete note',
                error: error.message,
            });
        }
    }

    @UseGuards(JwtAuthGuard)
    @Get(':id')
    async findById(@Param('id') id: string, @Headers() headers: any, @Res() res: Response) {
        try {
            const userId = headers['user-id'];
            if (!userId) {
                return res.status(HttpStatus.BAD_REQUEST).json({ message: 'User ID is required' });
            }
            const note = await this.notesService.findById(id, userId);
            return res.status(HttpStatus.OK).json(note);
        } catch (error) {
            return res.status(HttpStatus.INTERNAL_SERVER_ERROR).json({
                message: 'Failed to find note',
                error: error.message,
            });
        }
    }

    @UseGuards(JwtAuthGuard)
    @Get()
    async findAll(@Headers() headers: any, @Res() res: Response) {
        try {
            const userId = headers['user-id'];
            if (!userId) {
                return res.status(HttpStatus.BAD_REQUEST).json({ message: 'User ID is required' });
            }
            const notes = await this.notesService.findAll(userId);
            return res.status(HttpStatus.OK).json(notes);
        } catch (error) {
            return res.status(HttpStatus.INTERNAL_SERVER_ERROR).json({
                message: 'Failed to fetch notes',
                error: error.message,
            });
        }
    }

    @UseGuards(JwtAuthGuard)
    @Patch(':id')
    async update(@Body() updateNoteDto: UpdateNotesDto, @Param('id') id: string, @Headers() headers: any, @Res() res: Response) {
        try {
            const userId = headers['user-id'];
            if (!userId) {
                return res.status(HttpStatus.BAD_REQUEST).json({ message: 'User ID is required' });
            }
            const updatedNote = await this.notesService.update(id, updateNoteDto, userId);
            return res.status(HttpStatus.OK).json(updatedNote);
        } catch (error) {
            return res.status(HttpStatus.INTERNAL_SERVER_ERROR).json({
                message: 'Failed to update note',
                error: error.message,
            });
        }
    }
}