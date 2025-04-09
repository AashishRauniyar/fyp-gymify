
import React from 'react';
import { 
  Card, 
  CardContent, 
  CardDescription, 
  CardHeader, 
  CardTitle 
} from '@/components/ui/card';
import { activityLogs } from '@/lib/data';
import { format } from 'date-fns';

const RecentActivities = () => {
  return (
    <Card className="border border-border/50 shadow-sm">
      <CardHeader className="pb-2">
        <CardTitle>Recent Activities</CardTitle>
        <CardDescription>Latest activity in your gym</CardDescription>
      </CardHeader>
      <CardContent className="pt-0">
        <div className="space-y-4">
          {activityLogs.slice(0, 5).map((log) => (
            <div key={log.id} className="flex items-start space-x-4">
              <div className="w-2 h-2 mt-2 rounded-full bg-primary" />
              <div className="flex-1 space-y-1">
                <p className="text-sm font-medium">
                  <span className="font-semibold text-primary/90">{log.userName}</span>{' '}
                  {log.action} a {log.resourceType}
                  {log.details && <span className="text-muted-foreground"> - {log.details}</span>}
                </p>
                <p className="text-xs text-muted-foreground">
                  {format(new Date(log.timestamp), 'MMM d, yyyy h:mm a')}
                </p>
              </div>
            </div>
          ))}
        </div>
      </CardContent>
    </Card>
  );
};

export default RecentActivities;
