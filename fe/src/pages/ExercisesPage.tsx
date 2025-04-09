
import React, { useState } from 'react';
import DashboardLayout from '@/components/layout/DashboardLayout';
import { 
  Card, 
  CardContent, 
  CardDescription, 
  CardHeader, 
  CardTitle 
} from '@/components/ui/card';
import { Input } from '@/components/ui/input';
import { Button } from '@/components/ui/button';
import { Search, Plus, MoreHorizontal, Edit, Trash, Play, Filter } from 'lucide-react';
import { exercises } from '@/lib/data';
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu';
import { Badge } from '@/components/ui/badge';

const ExercisesPage = () => {
  const [searchTerm, setSearchTerm] = useState('');
  
  const filteredExercises = exercises.filter(exercise => 
    exercise.exercise_name.toLowerCase().includes(searchTerm.toLowerCase()) ||
    exercise.target_muscle_group.toLowerCase().includes(searchTerm.toLowerCase()) ||
    exercise.description.toLowerCase().includes(searchTerm.toLowerCase())
  );

  return (
    <DashboardLayout>
      <div className="space-y-6">
        <div className="flex justify-between items-center">
          <h1 className="text-2xl font-bold tracking-tight">Exercises</h1>
          <Button className="flex items-center gap-2">
            <Plus className="h-4 w-4" />
            Add Exercise
          </Button>
        </div>

        <Card>
          <CardHeader className="pb-3">
            <CardTitle>Exercise Library</CardTitle>
            <CardDescription>Browse and manage all exercises in your gym</CardDescription>
          </CardHeader>
          <CardContent>
            <div className="flex items-center justify-between mb-4">
              <div className="relative w-full max-w-sm">
                <Search className="absolute left-2.5 top-2.5 h-4 w-4 text-muted-foreground" />
                <Input
                  placeholder="Search exercises..."
                  className="pl-8"
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                />
              </div>
              
              <Button variant="outline" size="sm" className="flex items-center gap-2">
                <Filter className="h-4 w-4" />
                Filter
              </Button>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
              {filteredExercises.map(exercise => (
                <Card key={exercise.exercise_id} className="overflow-hidden flex flex-col">
                  <div className="aspect-video relative overflow-hidden">
                    {exercise.image_url ? (
                      <img 
                        src={exercise.image_url} 
                        alt={exercise.exercise_name} 
                        className="w-full h-full object-cover transition-transform duration-300 hover:scale-105"
                      />
                    ) : (
                      <div className="w-full h-full bg-muted flex items-center justify-center">
                        No Image
                      </div>
                    )}
                  </div>
                  <div className="p-4 flex-1 flex flex-col">
                    <div className="flex items-center justify-between">
                      <h3 className="font-medium">{exercise.exercise_name}</h3>
                      <Badge variant="outline" className="text-xs">
                        {exercise.target_muscle_group}
                      </Badge>
                    </div>
                    <p className="text-sm text-muted-foreground mt-2 line-clamp-2">
                      {exercise.description}
                    </p>
                    <div className="text-xs text-muted-foreground mt-2">
                      Calories: {exercise.calories_burned_per_minute} per minute
                    </div>
                    <div className="mt-auto pt-4 flex items-center justify-between">
                      <Button variant="outline" size="sm" className="flex items-center gap-2">
                        <Play className="h-3 w-3" />
                        Video
                      </Button>
                      <DropdownMenu>
                        <DropdownMenuTrigger asChild>
                          <Button variant="ghost" size="icon">
                            <MoreHorizontal className="h-4 w-4" />
                            <span className="sr-only">Actions</span>
                          </Button>
                        </DropdownMenuTrigger>
                        <DropdownMenuContent align="end">
                          <DropdownMenuLabel>Actions</DropdownMenuLabel>
                          <DropdownMenuItem>
                            <Edit className="mr-2 h-4 w-4" />
                            Edit
                          </DropdownMenuItem>
                          <DropdownMenuSeparator />
                          <DropdownMenuItem className="text-destructive">
                            <Trash className="mr-2 h-4 w-4" />
                            Delete
                          </DropdownMenuItem>
                        </DropdownMenuContent>
                      </DropdownMenu>
                    </div>
                  </div>
                </Card>
              ))}
            </div>
          </CardContent>
        </Card>
      </div>
    </DashboardLayout>
  );
};

export default ExercisesPage;
