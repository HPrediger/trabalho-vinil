import {
    Body,
    Controller,
    Delete,
    Get,
    Param,
    ParseIntPipe,
    Post,
    Put,
} from '@nestjs/common';

import { CreateGenreDto } from '../dtos/create-genre-dto';
import { UpdateGenreDto } from '../dtos/update-genre-dto';
import { GenresService } from './genres.service';
import { Roles } from '../auth/roles.decorator';

@Controller('genres')
export class GenresController {
    constructor(
        private genresService: GenresService,
    ) {}

    @Post()
    @Roles('ADMIN')
    async create(
        @Body() dto: CreateGenreDto,
    ) {
        return await this.genresService.create(dto);
    }

    @Get()
    async findAll() {
        return await this.genresService.findAll();
    }

    @Get(':id')
    async findOne(
        @Param('id', ParseIntPipe) id: number,
    ) {
        return await this.genresService.findOne(id);
    }

    @Put(':id')
    @Roles('ADMIN')
    async update(
        @Param('id', ParseIntPipe) id: number,
        @Body() dto: UpdateGenreDto,
    ) {
        return await this.genresService.update(
            id,
            dto,
        );
    }

    @Delete(':id')
    @Roles('ADMIN')
    async remove(
        @Param('id', ParseIntPipe) id: number,
    ) {
        return await this.genresService.remove(id);
    }
}