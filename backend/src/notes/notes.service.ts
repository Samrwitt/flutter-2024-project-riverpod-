import { Injectable, NotFoundException } from '@nestjs/common';
import { Note, NoteDocument } from './schemas/note.schema';
import { Model } from 'mongoose';
import { InjectModel } from '@nestjs/mongoose';
import { CreateNotesDto } from './dto/create-notes.dto';
import { UpdateNotesDto } from './dto/update-notes.dto';

@Injectable()
export class NotesService {
    constructor(@InjectModel(Note.name) private readonly noteModel: Model<NoteDocument>){}

    async create(createNoteDto: CreateNotesDto, userId: string): Promise<Note> {
        try {
            createNoteDto.userId = userId;

            const createdNote = new this.noteModel(createNoteDto);
            const savedNote = await createdNote.save();

            console.log('Note created successfully:', savedNote);
            return savedNote;
        } catch (error) {
            console.error('Error creating note:', error);
            throw new Error('Unable to create note');
        }
    }

    async remove(id: string, userId: string): Promise<Note> {
        const deletedNote = await this.noteModel.findOneAndDelete({
            _id: id,
            userId
        }).exec();

        if (!deletedNote) {
            throw new NotFoundException('Note not found');
        }

        return deletedNote;
    }

    async findById(id: string, userId: string): Promise<Note> {
        const note = await this.noteModel.findOne({
            _id: id,
            userId
        }).exec();

        if (!note) {
            throw new NotFoundException('Note not found');
        }
        return note;
    }

    async findAll(userId: string): Promise<Note[]> {
        console.log('Finding all notes for user ID:', userId);
        return this.noteModel.find({ userId }).exec();
    }

    async findAllNotesForAdmin(): Promise<Note[]> {
        return this.noteModel.find().exec();
    }

    async update(id: string, updateNoteDto: UpdateNotesDto, userId: string): Promise<Note> {
        const updatedNote = await this.noteModel
            .findOneAndUpdate(
                { _id: id, userId },
                { $set: { ...updateNoteDto, updatedAt: new Date() } },
                { new: true }
            ).exec();

        if (!updatedNote) {
            throw new NotFoundException('Note not found');
        }
        console.log("Successful update", updatedNote);
        return updatedNote;
    }
}