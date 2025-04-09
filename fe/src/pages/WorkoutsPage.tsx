
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
import { Search, Plus, MoreHorizontal, Edit, Trash, Filter } from 'lucide-react';
import { workouts, workoutExercises, exercises, users } from '@/lib/data';
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu';
import { Badge } from '@/components/ui/badge';
import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar';
import { DifficultyLevel, FitnessLevel, GoalType } from '@/types';

const WorkoutsPage = () => {
  const [searchTerm, setSearchTerm] = useState('');
  
  // Combine data to show trainer names
  const workoutData = workouts.map(workout => {
    const trainer = users.find(u => u.user_id === workout.trainer_id);
    const workoutExs = workoutExercises.filter(we => we.workout_id === workout.workout_id);
    const exerciseCount = workoutExs.length;
    
    return {
      ...workout,
      trainer_name: trainer?.full_name || 'Unknown',
      trainer_image: trainer?.profile_image,
      exercise_count: exerciseCount
    };
  });
  
  const filteredWorkouts = workoutData.filter(workout => 
    workout.workout_name.toLowerCase().includes(searchTerm.toLowerCase()) ||
    workout.target_muscle_group.toLowerCase().includes(searchTerm.toLowerCase()) ||
    workout.description.toLowerCase().includes(searchTerm.toLowerCase()) ||
    workout.trainer_name.toLowerCase().includes(searchTerm.toLowerCase())
  );

  const getDifficultyBadgeVariant = (difficulty: DifficultyLevel) => {
    switch (difficulty) {
      case DifficultyLevel.Easy:
        return 'outline';
      case DifficultyLevel.Intermediate:
        return 'default';
      case DifficultyLevel.Hard:
        return 'destructive';
      default:
        return 'secondary';
    }
  };

  return (
    <DashboardLayout>
      <div className="space-y-6">
        <div className="flex justify-between items-center">
          <h1 className="text-2xl font-bold tracking-tight">Workouts</h1>
          <Button className="flex items-center gap-2">
            <Plus className="h-4 w-4" />
            Create Workout
          </Button>
        </div>

        <Card>
          <CardHeader className="pb-3">
            <CardTitle>Workout Programs</CardTitle>
            <CardDescription>Manage all workout programs in your gym</CardDescription>
          </CardHeader>
          <CardContent>
            <div className="flex items-center justify-between mb-4">
              <div className="relative w-full max-w-sm">
                <Search className="absolute left-2.5 top-2.5 h-4 w-4 text-muted-foreground" />
                <Input
                  placeholder="Search workouts..."
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
              {filteredWorkouts.map(workout => (
                <Card key={workout.workout_id} className="overflow-hidden flex flex-col h-full">
                  <div className="aspect-video relative overflow-hidden">
                    {workout.workout_image ? (
                      <img 
                        src={workout.workout_image} 
                        alt={workout.workout_name} 
                        className="w-full h-full object-cover transition-transform duration-300 hover:scale-105"
                      />
                    ) : (
                      <div className="w-full h-full bg-muted flex items-center justify-center">
                        No Image
                      </div>
                    )}
                    <Badge 
                      variant={getDifficultyBadgeVariant(workout.difficulty)}
                      className="absolute top-2 right-2"
                    >
                      {workout.difficulty}
                    </Badge>
                  </div>
                  <div className="p-4 flex-1 flex flex-col">
                    <div className="flex items-center justify-between">
                      <h3 className="font-medium truncate">{workout.workout_name}</h3>
                    </div>
                    <div className="flex items-center gap-2 mt-1">
                      <Badge variant="outline" className="text-xs">
                        {workout.fitness_level}
                      </Badge>
                      <Badge variant="secondary" className="text-xs">
                        {workout.target_muscle_group}
                      </Badge>
                    </div>
                    <p className="text-sm text-muted-foreground mt-2 line-clamp-2">
                      {workout.description}
                    </p>
                    <div className="text-xs text-muted-foreground mt-2">
                      {workout.exercise_count} exercises
                    </div>
                    <div className="mt-auto pt-4 flex items-center justify-between">
                      <div className="flex items-center gap-2">
                        <Avatar className="h-6 w-6">
                          <AvatarImage src={workout.trainer_image} alt={workout.trainer_name} />
                          <AvatarFallback>
                            {workout.trainer_name.substring(0, 2).toUpperCase()}
                          </AvatarFallback>
                        </Avatar>
                        <span className="text-xs">{workout.trainer_name}</span>
                      </div>
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
                          <DropdownMenuItem>
                            View Details
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

export default WorkoutsPage;
