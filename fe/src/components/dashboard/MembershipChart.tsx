
import React from 'react';
import { 
  Card, 
  CardContent, 
  CardDescription, 
  CardHeader, 
  CardTitle 
} from '@/components/ui/card';
import { PieChart, Pie, Cell, ResponsiveContainer, Legend, Tooltip } from 'recharts';
import { membershipDistribution } from '@/lib/data';

const COLORS = ['#3b82f6', '#8b5cf6', '#ec4899'];

const MembershipChart = () => {
  return (
    <Card className="border border-border/50 shadow-sm">
      <CardHeader className="pb-2">
        <CardTitle>Membership Distribution</CardTitle>
        <CardDescription>Breakdown of membership types</CardDescription>
      </CardHeader>
      <CardContent className="pt-0">
        <div className="h-[240px] w-full">
          <ResponsiveContainer width="100%" height="100%">
            <PieChart>
              <Pie
                data={membershipDistribution}
                cx="50%"
                cy="50%"
                innerRadius={60}
                outerRadius={80}
                fill="#8884d8"
                paddingAngle={2}
                dataKey="value"
                label={({ name, percent }) => `${name} ${(percent * 100).toFixed(0)}%`}
                labelLine={false}
              >
                {membershipDistribution.map((entry, index) => (
                  <Cell key={`cell-${index}`} fill={COLORS[index % COLORS.length]} />
                ))}
              </Pie>
              <Tooltip 
                formatter={(value) => [`${value} members`, 'Count']}
              />
              <Legend />
            </PieChart>
          </ResponsiveContainer>
        </div>
      </CardContent>
    </Card>
  );
};

export default MembershipChart;
