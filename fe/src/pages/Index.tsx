import React, { useState, useEffect } from 'react';
import DashboardLayout from '@/components/layout/DashboardLayout';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { LineChart, BarChart, PieChart, Line, Bar, Pie, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer, Cell } from 'recharts';
import { ArrowUpIcon, ArrowDownIcon, UsersIcon, CreditCardIcon, CalendarIcon, TrendingUpIcon, ActivityIcon, DollarSign, Users, BarChart2, Calendar, Dumbbell } from 'lucide-react';
import { userInstance } from '@/network/axios';
import { useToast } from '@/components/ui/use-toast';
import { format } from 'date-fns';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';

// Custom color palette
const COLORS = ['#0088FE', '#00C49F', '#FFBB28', '#FF8042', '#8884d8', '#82ca9d', '#ffc658', '#8dd1e1'];

const Dashboard = () => {
  const { toast } = useToast();
  
  // State for dashboard data
  const [dashboardStats, setDashboardStats] = useState(null);
  const [monthlyRevenue, setMonthlyRevenue] = useState(null);
  const [userGrowth, setUserGrowth] = useState(null);
  const [attendanceTrends, setAttendanceTrends] = useState(null);
  const [demographics, setDemographics] = useState(null);
  
  // State for loading and errors
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  
  // State for filter options
  const [selectedYear, setSelectedYear] = useState(new Date().getFullYear());
  const [selectedDays, setSelectedDays] = useState('30');
  
  // Get available years for the dropdowns
  const currentYear = new Date().getFullYear();
  const yearOptions = Array.from({ length: 5 }, (_, i) => currentYear - i);

  // Fetch all dashboard data on component mount
  useEffect(() => {
    fetchDashboardStats();
  }, []);

  // Fetch data when filters change
  useEffect(() => {
    fetchMonthlyRevenue(selectedYear);
    fetchUserGrowth(selectedYear);
  }, [selectedYear]);

  useEffect(() => {
    fetchAttendanceTrends(selectedDays);
  }, [selectedDays]);

  // Fetch dashboard summary statistics
  const fetchDashboardStats = async () => {
    setLoading(true);
    try {
      const response = await userInstance.get('/admin/dashboard/stats');
      setDashboardStats(response.data.data);
      
      // After getting main stats, fetch additional data
      fetchMonthlyRevenue(selectedYear);
      fetchUserGrowth(selectedYear);
      fetchAttendanceTrends(selectedDays);
      fetchUserDemographics();
    } catch (err) {
      console.error('Error fetching dashboard stats:', err);
      setError('Failed to load dashboard statistics');
      toast({
        title: "Error",
        description: "Failed to load dashboard statistics. Please try again.",
        variant: "destructive",
      });
    } finally {
      setLoading(false);
    }
  };

  // Fetch monthly revenue data
  const fetchMonthlyRevenue = async (year) => {
    try {
      const response = await userInstance.get(`/admin/dashboard/revenue?year=${year}`);
      setMonthlyRevenue(response.data.data);
    } catch (err) {
      console.error('Error fetching monthly revenue:', err);
      toast({
        title: "Error",
        description: "Failed to load revenue data. Please try again.",
        variant: "destructive",
      });
    }
  };

  // Fetch user growth statistics
  const fetchUserGrowth = async (year) => {
    try {
      const response = await userInstance.get(`/admin/dashboard/user-growth?year=${year}`);
      setUserGrowth(response.data.data);
    } catch (err) {
      console.error('Error fetching user growth:', err);
      toast({
        title: "Error",
        description: "Failed to load user growth data. Please try again.",
        variant: "destructive",
      });
    }
  };

  // Fetch attendance trends
  const fetchAttendanceTrends = async (days) => {
    try {
      const response = await userInstance.get(`/admin/dashboard/attendance-trends?days=${days}`);
      setAttendanceTrends(response.data.data);
    } catch (err) {
      console.error('Error fetching attendance trends:', err);
      toast({
        title: "Error",
        description: "Failed to load attendance data. Please try again.",
        variant: "destructive",
      });
    }
  };

  // Fetch user demographics
  const fetchUserDemographics = async () => {
    try {
      const response = await userInstance.get('/admin/dashboard/user-demographics');
      setDemographics(response.data.data);
    } catch (err) {
      console.error('Error fetching user demographics:', err);
      toast({
        title: "Error",
        description: "Failed to load demographics data. Please try again.",
        variant: "destructive",
      });
    }
  };

  // Format currency
  const formatCurrency = (amount) => {
    return new Intl.NumberFormat('en-US', {
      style: 'currency',
      currency: 'NPR',
      minimumFractionDigits: 2
    }).format(amount);
  };

  // Helper to format percentage with sign
  const formatPercentage = (value) => {
    const isPositive = value >= 0;
    return `${isPositive ? '+' : ''}${value.toFixed(2)}%`;
  };

  // Loading state
  if (loading && !dashboardStats) {
    return (
      <DashboardLayout>
        <div className="flex items-center justify-center h-full p-8">
          <div className="text-center">
            <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary mx-auto mb-4"></div>
            <p className="text-muted-foreground">Loading dashboard data...</p>
            {error && <p className="text-red-500 mt-2">Error: {error}</p>}
          </div>
        </div>
      </DashboardLayout>
    );
  }

  return (
    <DashboardLayout>
      <div className="flex flex-col gap-6 p-6">
        <div className="flex flex-col md:flex-row justify-between items-start md:items-center">
          <h1 className="text-2xl font-bold tracking-tight">Admin Dashboard</h1>
          <div className="flex gap-2 mt-2 md:mt-0">
            <Select value={selectedYear.toString()} onValueChange={(value) => setSelectedYear(parseInt(value))}>
              <SelectTrigger className="w-[110px]">
                <SelectValue placeholder="Select Year" />
              </SelectTrigger>
              <SelectContent>
                {yearOptions.map((year) => (
                  <SelectItem key={year} value={year.toString()}>{year}</SelectItem>
                ))}
              </SelectContent>
            </Select>
            
            <Select value={selectedDays} onValueChange={setSelectedDays}>
              <SelectTrigger className="w-[150px]">
                <SelectValue placeholder="Attendance Period" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="7">Last 7 days</SelectItem>
                <SelectItem value="30">Last 30 days</SelectItem>
                <SelectItem value="90">Last 90 days</SelectItem>
              </SelectContent>
            </Select>
          </div>
        </div>

        {/* Summary Stats Cards */}
        {dashboardStats && (
          <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
            {/* User Stats Card */}
            <Card>
              <CardHeader className="flex flex-row items-center justify-between pb-2">
                <CardTitle className="text-sm font-medium">Total Members</CardTitle>
                <Users className="h-4 w-4 text-muted-foreground" />
              </CardHeader>
              <CardContent>
                <div className="text-2xl font-bold">{dashboardStats.userStats.totalUsers}</div>
                <div className="flex items-center mt-1">
                  <span className={`text-xs ${dashboardStats.userStats.userGrowthRate >= 0 ? 'text-green-500' : 'text-red-500'} flex items-center`}>
                    {dashboardStats.userStats.userGrowthRate >= 0 ? (
                      <ArrowUpIcon className="h-3 w-3 mr-1" />
                    ) : (
                      <ArrowDownIcon className="h-3 w-3 mr-1" />
                    )}
                    {formatPercentage(dashboardStats.userStats.userGrowthRate)}
                  </span>
                  <span className="text-xs text-muted-foreground ml-1">vs last month</span>
                </div>
                <p className="text-xs text-muted-foreground mt-2">
                  {dashboardStats.userStats.newUsersThisMonth} new members this month
                </p>
              </CardContent>
            </Card>

            {/* Revenue Stats Card */}
            <Card>
              <CardHeader className="flex flex-row items-center justify-between pb-2">
                <CardTitle className="text-sm font-medium">Monthly Revenue</CardTitle>
                {/* <DollarSign className="h-4 w-4 text-muted-foreground" /> */}
              </CardHeader>
              <CardContent>
                <div className="text-2xl font-bold">
                  {formatCurrency(dashboardStats.revenueStats.thisMonthRevenue)}
                </div>
                <div className="flex items-center mt-1">
                  <span className={`text-xs ${dashboardStats.revenueStats.revenueGrowthRate >= 0 ? 'text-green-500' : 'text-red-500'} flex items-center`}>
                    {dashboardStats.revenueStats.revenueGrowthRate >= 0 ? (
                      <ArrowUpIcon className="h-3 w-3 mr-1" />
                    ) : (
                      <ArrowDownIcon className="h-3 w-3 mr-1" />
                    )}
                    {formatPercentage(dashboardStats.revenueStats.revenueGrowthRate)}
                  </span>
                  <span className="text-xs text-muted-foreground ml-1">vs last month</span>
                </div>
                <p className="text-xs text-muted-foreground mt-2">
                  {formatCurrency(dashboardStats.revenueStats.prevMonthRevenue)} last month
                </p>
              </CardContent>
            </Card>

            {/* Membership Stats Card */}
            <Card>
              <CardHeader className="flex flex-row items-center justify-between pb-2">
                <CardTitle className="text-sm font-medium">Active Memberships</CardTitle>
                <CreditCardIcon className="h-4 w-4 text-muted-foreground" />
              </CardHeader>
              <CardContent>
                <div className="text-2xl font-bold">{dashboardStats.membershipStats.activeMemberships}</div>
                <div className="mt-1 flex flex-col">
                  <div className="flex items-center">
                    <span className="text-yellow-500 text-xs flex items-center">
                      <ActivityIcon className="h-3 w-3 mr-1" />
                      {dashboardStats.membershipStats.pendingMemberships}
                    </span>
                    <span className="text-xs text-muted-foreground ml-1">pending approval</span>
                  </div>
                  <div className="flex items-center mt-1">
                    <span className="text-orange-500 text-xs flex items-center">
                      <CalendarIcon className="h-3 w-3 mr-1" />
                      {dashboardStats.membershipStats.expiringMemberships}
                    </span>
                    <span className="text-xs text-muted-foreground ml-1">expiring soon</span>
                  </div>
                </div>
              </CardContent>
            </Card>

            {/* Attendance Stats Card */}
            <Card>
              <CardHeader className="flex flex-row items-center justify-between pb-2">
                <CardTitle className="text-sm font-medium">Today's Attendance</CardTitle>
                <Calendar className="h-4 w-4 text-muted-foreground" />
              </CardHeader>
              <CardContent>
                <div className="text-2xl font-bold">{dashboardStats.attendanceStats.todayAttendance}</div>
                <p className="text-xs text-muted-foreground mt-3">
                  {format(new Date(), 'EEEE, MMMM d, yyyy')}
                </p>
              </CardContent>
            </Card>
          </div>
        )}

        {/* Top 5 Popular Workouts */}
        {dashboardStats && dashboardStats.popularWorkouts?.length > 0 && (
          <Card className="col-span-2">
            <CardHeader>
              <CardTitle>Most Popular Workouts</CardTitle>
              <CardDescription>Top 5 most frequently logged workouts</CardDescription>
            </CardHeader>
            <CardContent>
              <div className="overflow-x-auto">
                <table className="w-full">
                  <thead>
                    <tr className="border-b">
                      <th className="text-left py-3 px-2 font-medium">Workout</th>
                      <th className="text-left py-3 px-2 font-medium">Target Muscles</th>
                      <th className="text-left py-3 px-2 font-medium">Goal Type</th>
                      <th className="text-left py-3 px-2 font-medium">Difficulty</th>
                      <th className="text-right py-3 px-2 font-medium">Times Logged</th>
                    </tr>
                  </thead>
                  <tbody>
                    {dashboardStats.popularWorkouts.map((workout, index) => (
                      <tr key={index} className="border-b last:border-0">
                        <td className="py-3 px-2">{workout.workout_name}</td>
                        <td className="py-3 px-2">{workout.target_muscle_group || 'N/A'}</td>
                        <td className="py-3 px-2">
                          <span className="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-blue-100 text-blue-800">
                            {workout.goal_type?.replace('_', ' ') || 'N/A'}
                          </span>
                        </td>
                        <td className="py-3 px-2">
                          <span className={`inline-flex items-center px-2 py-1 rounded-full text-xs font-medium ${
                            workout.difficulty === 'Easy' ? 'bg-green-100 text-green-800' :
                            workout.difficulty === 'Intermediate' ? 'bg-yellow-100 text-yellow-800' :
                            workout.difficulty === 'Hard' ? 'bg-red-100 text-red-800' : 'bg-gray-100 text-gray-800'
                          }`}>
                            {workout.difficulty || 'N/A'}
                          </span>
                        </td>
                        <td className="py-3 px-2 text-right font-medium">{workout.count}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </CardContent>
          </Card>
        )}

        {/* Dashboard Tabs for Charts */}
        <Tabs defaultValue="revenue" className="w-full">
          <TabsList className="grid w-full grid-cols-4">
            <TabsTrigger value="revenue">Revenue</TabsTrigger>
            <TabsTrigger value="users">User Growth</TabsTrigger>
            <TabsTrigger value="attendance">Attendance</TabsTrigger>
            <TabsTrigger value="demographics">Demographics</TabsTrigger>
          </TabsList>
          
          {/* Revenue Tab */}
          <TabsContent value="revenue">
            <Card>
              <CardHeader>
                <CardTitle>Monthly Revenue ({selectedYear})</CardTitle>
                <CardDescription>
                  Revenue generated from memberships and payments
                </CardDescription>
              </CardHeader>
              <CardContent className="h-96">
                {monthlyRevenue ? (
                  <ResponsiveContainer width="100%" height="100%">
                    <LineChart
                      data={monthlyRevenue.monthly_data}
                      margin={{ top: 20, right: 30, left: 20, bottom: 30 }}
                    >
                      <CartesianGrid strokeDasharray="3 3" />
                      <XAxis dataKey="month_name" />
                      <YAxis
                        tickFormatter={(value) => `NPR ${value}`}
                      />
                      <Tooltip
                        formatter={(value) => [`NPR ${value}`, 'Revenue']}
                      />
                      <Legend />
                      <Line
                        type="monotone"
                        dataKey="revenue"
                        name="Revenue"
                        stroke="#0088FE"
                        activeDot={{ r: 8 }}
                        strokeWidth={2}
                      />
                      {monthlyRevenue.previous_year_data && (
                        <Line
                          type="monotone"
                          dataKey={(_, index) => monthlyRevenue.previous_year_data[index]?.revenue || 0}
                          name={`${selectedYear-1} Revenue`}
                          stroke="#82ca9d"
                          strokeDasharray="3 3"
                        />
                      )}
                    </LineChart>
                  </ResponsiveContainer>
                ) : (
                  <div className="flex items-center justify-center h-full">
                    <p className="text-muted-foreground">Loading revenue data...</p>
                  </div>
                )}
              </CardContent>
            </Card>
          </TabsContent>
          
          {/* User Growth Tab */}
          <TabsContent value="users">
            <Card>
              <CardHeader>
                <CardTitle>User Growth ({selectedYear})</CardTitle>
                <CardDescription>
                  Monthly new user registrations and cumulative growth
                </CardDescription>
              </CardHeader>
              <CardContent className="h-96">
                {userGrowth ? (
                  <ResponsiveContainer width="100%" height="100%">
                    <BarChart
                      data={userGrowth.monthly_data}
                      margin={{ top: 20, right: 30, left: 20, bottom: 30 }}
                    >
                      <CartesianGrid strokeDasharray="3 3" />
                      <XAxis dataKey="month_name" />
                      <YAxis />
                      <Tooltip />
                      <Legend />
                      <Bar dataKey="total" name="Total New Users" fill="#0088FE" />
                      <Bar dataKey="members" name="Members" fill="#00C49F" />
                      <Bar dataKey="trainers" name="Trainers" fill="#FFBB28" />
                      <Line
                        type="monotone"
                        dataKey={(_, index) => userGrowth.cumulative_data[index]?.cumulative || 0}
                        name="Cumulative Users"
                        stroke="#ff7300"
                        strokeWidth={2}
                        yAxisId={1}
                      />
                    </BarChart>
                  </ResponsiveContainer>
                ) : (
                  <div className="flex items-center justify-center h-full">
                    <p className="text-muted-foreground">Loading user growth data...</p>
                  </div>
                )}
              </CardContent>
            </Card>
          </TabsContent>
          
          {/* Attendance Tab */}
          <TabsContent value="attendance">
            <Card>
              <CardHeader>
                <CardTitle>Attendance Trends (Last {selectedDays} Days)</CardTitle>
                <CardDescription>
                  Daily gym attendance across all locations
                </CardDescription>
              </CardHeader>
              <CardContent className="h-96">
                {attendanceTrends ? (
                  <ResponsiveContainer width="100%" height="100%">
                    <LineChart
                      data={attendanceTrends.attendance}
                      margin={{ top: 20, right: 30, left: 20, bottom: 30 }}
                    >
                      <CartesianGrid strokeDasharray="3 3" />
                      <XAxis dataKey="date" />
                      <YAxis />
                      <Tooltip />
                      <Legend />
                      <Line
                        type="monotone"
                        dataKey="total"
                        name="Total Attendance"
                        stroke="#8884d8"
                        strokeWidth={2}
                      />
                      {attendanceTrends.gyms.map((gym, index) => (
                        <Line
                          key={gym.id}
                          type="monotone"
                          dataKey={gym.key}
                          name={gym.name}
                          stroke={COLORS[index % COLORS.length]}
                        />
                      ))}
                    </LineChart>
                  </ResponsiveContainer>
                ) : (
                  <div className="flex items-center justify-center h-full">
                    <p className="text-muted-foreground">Loading attendance data...</p>
                  </div>
                )}
              </CardContent>
            </Card>
          </TabsContent>
          
          {/* Demographics Tab */}
          <TabsContent value="demographics">
            <div className="grid gap-4 md:grid-cols-2">
              {/* Gender Distribution */}
              <Card>
                <CardHeader>
                  <CardTitle>Gender Distribution</CardTitle>
                </CardHeader>
                <CardContent className="h-72">
                  {demographics?.genderDistribution ? (
                    <ResponsiveContainer width="100%" height="100%">
                      <PieChart>
                        <Pie
                          data={demographics.genderDistribution}
                          dataKey="count"
                          nameKey="gender"
                          cx="50%"
                          cy="50%"
                          outerRadius={80}
                          fill="#8884d8"
                          label={({gender, count, percent}) => `${gender}: ${count} (${(percent * 100).toFixed(0)}%)`}
                        >
                          {demographics.genderDistribution.map((entry, index) => (
                            <Cell key={`cell-${index}`} fill={COLORS[index % COLORS.length]} />
                          ))}
                        </Pie>
                        <Tooltip formatter={(value, name) => [`${value} users`, `Gender: ${name}`]} />
                        <Legend />
                      </PieChart>
                    </ResponsiveContainer>
                  ) : (
                    <div className="flex items-center justify-center h-full">
                      <p className="text-muted-foreground">Loading gender data...</p>
                    </div>
                  )}
                </CardContent>
              </Card>
              
              {/* Age Distribution */}
              <Card>
                <CardHeader>
                  <CardTitle>Age Distribution</CardTitle>
                </CardHeader>
                <CardContent className="h-72">
                  {demographics?.ageDistribution ? (
                    <ResponsiveContainer width="100%" height="100%">
                      <BarChart
                        data={demographics.ageDistribution}
                        margin={{ top: 20, right: 30, left: 20, bottom: 5 }}
                      >
                        <CartesianGrid strokeDasharray="3 3" />
                        <XAxis dataKey="age_group" />
                        <YAxis />
                        <Tooltip />
                        <Legend />
                        <Bar dataKey="count" name="Users" fill="#8884d8">
                          {demographics.ageDistribution.map((entry, index) => (
                            <Cell key={`cell-${index}`} fill={COLORS[index % COLORS.length]} />
                          ))}
                        </Bar>
                      </BarChart>
                    </ResponsiveContainer>
                  ) : (
                    <div className="flex items-center justify-center h-full">
                      <p className="text-muted-foreground">Loading age data...</p>
                    </div>
                  )}
                </CardContent>
              </Card>
              
              {/* Fitness Level Distribution */}
              <Card>
                <CardHeader>
                  <CardTitle>Fitness Level Distribution</CardTitle>
                </CardHeader>
                <CardContent className="h-72">
                  {demographics?.fitnessLevelDistribution ? (
                    <ResponsiveContainer width="100%" height="100%">
                      <PieChart>
                        <Pie
                          data={demographics.fitnessLevelDistribution}
                          dataKey="count"
                          nameKey="fitness_level"
                          cx="50%"
                          cy="50%"
                          outerRadius={80}
                          fill="#8884d8"
                          label={({fitness_level, count, percent}) => 
                            `${fitness_level}: ${count} (${(percent * 100).toFixed(0)}%)`}
                        >
                          {demographics.fitnessLevelDistribution.map((entry, index) => (
                            <Cell key={`cell-${index}`} fill={COLORS[index % COLORS.length]} />
                          ))}
                        </Pie>
                        <Tooltip formatter={(value, name) => [`${value} users`, `Level: ${name}`]} />
                        <Legend />
                      </PieChart>
                    </ResponsiveContainer>
                  ) : (
                    <div className="flex items-center justify-center h-full">
                      <p className="text-muted-foreground">Loading fitness level data...</p>
                    </div>
                  )}
                </CardContent>
              </Card>
              
              {/* Goal Type Distribution */}
              <Card>
                <CardHeader>
                  <CardTitle>Fitness Goal Distribution</CardTitle>
                </CardHeader>
                <CardContent className="h-72">
                  {demographics?.goalTypeDistribution ? (
                    <ResponsiveContainer width="100%" height="100%">
                      <BarChart
                        data={demographics.goalTypeDistribution}
                        margin={{ top: 20, right: 30, left: 20, bottom: 5 }}
                        layout="vertical"
                      >
                        <CartesianGrid strokeDasharray="3 3" />
                        <XAxis type="number" />
                        <YAxis type="category" dataKey="goal_type" width={90} />
                        <Tooltip />
                        <Legend />
                        <Bar dataKey="count" name="Users" fill="#8884d8">
                          {demographics.goalTypeDistribution.map((entry, index) => (
                            <Cell key={`cell-${index}`} fill={COLORS[index % COLORS.length]} />
                          ))}
                        </Bar>
                      </BarChart>
                    </ResponsiveContainer>
                  ) : (
                    <div className="flex items-center justify-center h-full">
                      <p className="text-muted-foreground">Loading goal data...</p>
                    </div>
                  )}
                </CardContent>
              </Card>
            </div>
          </TabsContent>
        </Tabs>
      </div>
    </DashboardLayout>
  );
};

export default Dashboard;