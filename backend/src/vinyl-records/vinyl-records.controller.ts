import {
    Body,
    Controller,
    Delete,
    Get,
    Param,
    ParseIntPipe,
    Post,
    Put,
    Query,
} from '@nestjs/common';

import { CreateVinylRecordDto } from '../dtos/create-vinyl-record-dto';
import { UpdateVinylRecordDto } from '../dtos/update-vinyl-record-dto';
import { VinylRecordsService } from './vinyl-records.service';
import { FilterVinylRecordsDto } from '../dtos/filter-vinyl-records-dto';
import { Roles } from '../auth/roles.decorator';

@Controller('vinyl-records')
export class VinylRecordsController {
    constructor(
        private vinylRecordsService:
            VinylRecordsService,
    ) { }

    @Post()
    @Roles('ADMIN')
    async create(
        @Body() dto: CreateVinylRecordDto,
    ) {
        return await this.vinylRecordsService.create(
            dto,
        );
    }

    @Get()
    async findAll(
        @Query() filters: FilterVinylRecordsDto,
    ) {
        return await this.vinylRecordsService.findAll(
            filters,
        );
    }

    @Get(':id')
    async findOne(
        @Param('id', ParseIntPipe) id: number,
    ) {
        return await this.vinylRecordsService.findOne(
            id,
        );
    }

    @Put(':id')
    @Roles('ADMIN')
    async update(
        @Param('id', ParseIntPipe) id: number,
        @Body() dto: UpdateVinylRecordDto,
    ) {
        return await this.vinylRecordsService.update(
            id,
            dto,
        );
    }

    @Delete(':id')
    @Roles('ADMIN')
    async remove(
        @Param('id', ParseIntPipe) id: number,
    ) {
        return await this.vinylRecordsService.remove(
            id,
        );
    }
}