
import React from 'react';
import { 
  Card, 
  CardContent, 
  CardDescription, 
  CardHeader, 
  CardTitle 
} from '@/components/ui/card';
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from 'recharts';
import { revenueData } from '@/lib/data';

const RevenueChart = () => {
  return (
    <Card className="border border-border/50 shadow-sm">
      <CardHeader className="pb-2">
        <CardTitle>Monthly Revenue</CardTitle>
        <CardDescription>Revenue generated over time</CardDescription>
      </CardHeader>
      <CardContent className="pt-0">
        <div className="h-[300px] w-full">
          <ResponsiveContainer width="100%" height="100%">
            <BarChart
              data={revenueData}  
              margin={{
                top: 20,
                right: 30,
                left: 20,
                bottom: 5,
              }}>
              <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#f0f0f0" />
              <XAxis dataKey="name" stroke="#888888" fontSize={12} tickLine={false} axisLine={false} />
              <YAxis
                stroke="#888888"
                fontSize={12}
                tickLine={false}
                axisLine={false}
                tickFormatter={(value) => `$${value}`}
              />
              <Tooltip 
                cursor={{ fill: 'rgba(59, 130, 246, 0.1)' }}
                formatter={(value) => [`$${value}`, 'Revenue']}
              />
              <Bar 
                dataKey="value" 
                fill="#3b82f6" 
                radius={[4, 4, 0, 0]} 
                barSize={40}
              />
            </BarChart>
          </ResponsiveContainer>
        </div>
      </CardContent>
    </Card>
  );
};

export default RevenueChart;
