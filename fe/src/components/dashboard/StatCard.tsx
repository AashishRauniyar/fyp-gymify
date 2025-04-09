
import React from 'react';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { cn } from '@/lib/utils';
import { StatCardProps } from '@/types';

const StatCard: React.FC<StatCardProps> = ({ 
  title, 
  value, 
  icon: Icon, 
  description, 
  trend,
  onClick 
}) => {
  return (
    <Card 
      className={cn(
        "rounded-lg border border-border/50 shadow-sm transition-all duration-200",
        onClick && "cursor-pointer hover:shadow-md hover:border-primary/30"
      )}
      onClick={onClick}
    >
      <CardHeader className="flex flex-row items-center justify-between pb-2 space-y-0">
        <CardTitle className="text-sm font-medium text-muted-foreground">{title}</CardTitle>
        <div className="w-8 h-8 bg-primary/10 rounded-full flex items-center justify-center">
          <Icon className="h-4 w-4 text-primary" />
        </div>
      </CardHeader>
      <CardContent>
        <div className="text-2xl font-bold">{value}</div>
        {(description || trend !== undefined) && (
          <div className="flex items-center mt-1">
            {trend !== undefined && (
              <span 
                className={cn(
                  "text-xs font-medium mr-2",
                  trend > 0 ? "text-green-600" : trend < 0 ? "text-red-600" : "text-gray-600"
                )}
              >
                {trend > 0 ? `+${trend}%` : trend < 0 ? `${trend}%` : "0%"}
              </span>
            )}
            {description && (
              <p className="text-xs text-muted-foreground">{description}</p>
            )}
          </div>
        )}
      </CardContent>
    </Card>
  );
};

export default StatCard;
