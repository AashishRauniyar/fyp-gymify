import React, { useState, useEffect } from 'react';
import DashboardLayout from '@/components/layout/DashboardLayout';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { Button } from '@/components/ui/button';
import { 
  BarChart, 
  PieChart, 
  LineChart, 
  Bar, 
  Pie, 
  Line, 
  XAxis, 
  YAxis, 
  CartesianGrid, 
  Tooltip, 
  Legend, 
  ResponsiveContainer,
  Cell
} from 'recharts';
import { Download, Users, TrendingUp, Activity, Dumbbell, Target, Heart, Calendar } from 'lucide-react';
import { userInstance } from '@/network/axios';
import { useToast } from '@/components/ui/use-toast';
import { format, subMonths } from 'date-fns';

// Custom color palette
const COLORS = ['#0088FE', '#00C49F', '#FFBB28', '#FF8042', '#8884d8', '#82ca9d', '#ffc658', '#8dd1e1'];

const UserAnalyticsPage = () => {
  const { toast } = useToast();
  
  // State for analytics data
  const [userGrowth, setUserGrowth] = useState(null);
  const [demographics, setDemographics] = useState(null);
  const [attendanceTrends, setAttendanceTrends] = useState(null);
  
  // State for filters
  const [selectedYear, setSelectedYear] = useState(new Date().getFullYear());
  const [selectedDays, setSelectedDays] = useState('30');
  
  // State for loading and error
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  
  // Get available years for the dropdown
  const currentYear = new Date().getFullYear();
  const yearOptions = Array.from({ length: 5 }, (_, i) => currentYear - i);

  // Fetch data on component mount
  useEffect(() => {
    Promise.all([
      fetchUserGrowth(selectedYear),
      fetchUserDemographics(),
      fetchAttendanceTrends(selectedDays)
    ]).then(() => {
      setLoading(false);
    }).catch(err => {
      setError('Failed to load analytics data');
      setLoading(false);
    });
  }, []);

  // Fetch data when filters change
  useEffect(() => {
    fetchUserGrowth(selectedYear);
  }, [selectedYear]);

  useEffect(() => {
    fetchAttendanceTrends(selectedDays);
  }, [selectedDays]);

  // Fetch user growth statistics
  const fetchUserGrowth = async (year) => {
    try {
      const response = await userInstance.get(`/admin/dashboard/user-growth?year=${year}`);
      setUserGrowth(response.data.data);
      return response.data.data;
    } catch (err) {
      console.error('Error fetching user growth:', err);
      toast({
        title: "Error",
        description: "Failed to load user growth data. Please try again.",
        variant: "destructive",
      });
      throw err;
    }
  };

  // Fetch user demographics
  const fetchUserDemographics = async () => {
    try {
      const response = await userInstance.get('/admin/dashboard/user-demographics');
      setDemographics(response.data.data);
      return response.data.data;
    } catch (err) {
      console.error('Error fetching user demographics:', err);
      toast({
        title: "Error",
        description: "Failed to load demographics data. Please try again.",
        variant: "destructive",
      });
      throw err;
    }
  };

  // Fetch attendance trends
  const fetchAttendanceTrends = async (days) => {
    try {
      const response = await userInstance.get(`/admin/dashboard/attendance-trends?days=${days}`);
      setAttendanceTrends(response.data.data);
      return response.data.data;
    } catch (err) {
      console.error('Error fetching attendance trends:', err);
      toast({
        title: "Error",
        description: "Failed to load attendance data. Please try again.",
        variant: "destructive",
      });
      throw err;
    }
  };

  // Handle export to CSV
  const handleExportCSV = (dataType) => {
    let csvContent = '';
    let fileName = '';
    
    // Create different exports based on data type
    if (dataType === 'growth' && userGrowth) {
      // Create CSV header
      const headers = ['Month', 'New Users', 'New Members', 'New Trainers', 'Cumulative Users'].join(',');
      
      // Create CSV rows
      const rows = userGrowth.monthly_data.map((month, index) => [
        month.month_name,
        month.total,
        month.members,
        month.trainers,
        userGrowth.cumulative_data[index].cumulative
      ].join(','));
      
      csvContent = [headers, ...rows].join('\n');
      fileName = `user_growth_${selectedYear}.csv`;
    } 
    else if (dataType === 'demographics' && demographics) {
      // Export gender demographics
      const genderHeaders = ['Gender', 'Count'].join(',');
      const genderRows = demographics.genderDistribution.map(item => [
        item.gender,
        item.count
      ].join(','));
      
      // Add age group demographics
      const ageHeaders = ['Age Group', 'Count'].join(',');
      const ageRows = demographics.ageDistribution.map(item => [
        item.age_group,
        item.count
      ].join(','));
      
      // Add fitness level demographics
      const fitnessHeaders = ['Fitness Level', 'Count'].join(',');
      const fitnessRows = demographics.fitnessLevelDistribution.map(item => [
        item.fitness_level,
        item.count
      ].join(','));
      
      // Add goal type demographics
      const goalHeaders = ['Goal Type', 'Count'].join(',');
      const goalRows = demographics.goalTypeDistribution.map(item => [
        item.goal_type,
        item.count
      ].join(','));
      
      // Combine all demographics into one CSV
      csvContent = 
        'Gender Demographics\n' +
        [genderHeaders, ...genderRows].join('\n') +
        '\n\nAge Demographics\n' +
        [ageHeaders, ...ageRows].join('\n') +
        '\n\nFitness Level Demographics\n' +
        [fitnessHeaders, ...fitnessRows].join('\n') +
        '\n\nGoal Type Demographics\n' +
        [goalHeaders, ...goalRows].join('\n');
        
      fileName = `user_demographics_${format(new Date(), 'yyyy-MM-dd')}.csv`;
    }
    else if (dataType === 'attendance' && attendanceTrends) {
      // Create CSV header
      const headers = ['Date', 'Total Attendance', ...attendanceTrends.gyms.map(gym => gym.name)].join(',');
      
      // Create CSV rows
      const rows = attendanceTrends.attendance.map(day => [
        day.date,
        day.total,
        ...attendanceTrends.gyms.map(gym => day[gym.key] || 0)
      ].join(','));
      
      csvContent = [headers, ...rows].join('\n');
      fileName = `attendance_trends_${format(new Date(), 'yyyy-MM-dd')}.csv`;
    }
    
    if (csvContent && fileName) {
      // Create a blob and download link
      const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
      const url = URL.createObjectURL(blob);
      const link = document.createElement('a');
      link.setAttribute('href', url);
      link.setAttribute('download', fileName);
      link.style.display = 'none';
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);
    }
  };

  // Format number with comma separators
  const formatNumber = (num) => {
    return new Intl.NumberFormat().format(num);
  };

  // Calculate percentage
  const calculatePercentage = (value, total) => {
    if (!total) return '0%';
    return `${((value / total) * 100).toFixed(1)}%`;
  };

  // Loading state
  if (loading) {
    return (
      <DashboardLayout>
        <div className="flex items-center justify-center h-full p-8">
          <div className="text-center">
            <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary mx-auto mb-4"></div>
            <p className="text-muted-foreground">Loading user analytics data...</p>
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
          <div>
            <h1 className="text-2xl font-bold tracking-tight">User Analytics</h1>
            <p className="text-muted-foreground">Analyze user demographics and growth trends</p>
          </div>
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

        {/* Dashboard Tabs for Analytics */}
        <Tabs defaultValue="growth" className="w-full">
          <TabsList className="grid w-full grid-cols-3">
            <TabsTrigger value="growth">User Growth</TabsTrigger>
            <TabsTrigger value="demographics">Demographics</TabsTrigger>
            <TabsTrigger value="attendance">Gym Attendance</TabsTrigger>
          </TabsList>
          
          {/* User Growth Tab */}
          <TabsContent value="growth">
            <Card>
              <CardHeader className="flex flex-row justify-between items-center">
                <div>
                  <CardTitle>User Growth Trends ({selectedYear})</CardTitle>
                  <CardDescription>Monthly new user registrations and cumulative growth</CardDescription>
                </div>
                <Button variant="outline" size="sm" onClick={() => handleExportCSV('growth')}>
                  <Download className="h-4 w-4 mr-2" />
                  Export
                </Button>
              </CardHeader>
              <CardContent>
                <div className="grid grid-cols-1 md:grid-cols-4 gap-4 mb-6">
                  {userGrowth && (
                    <>
                      <Card>
                        <CardHeader className="p-4 pb-2">
                          <CardTitle className="text-sm">Total Users</CardTitle>
                        </CardHeader>
                        <CardContent className="p-4 pt-0">
                          <div className="text-2xl font-bold">
                            {formatNumber(userGrowth.starting_user_count + userGrowth.total_new_users)}
                          </div>
                          <p className="text-xs text-muted-foreground">
                            End of {selectedYear}
                          </p>
                        </CardContent>
                      </Card>
                      
                      <Card>
                        <CardHeader className="p-4 pb-2">
                          <CardTitle className="text-sm">New Users</CardTitle>
                        </CardHeader>
                        <CardContent className="p-4 pt-0">
                          <div className="text-2xl font-bold">{formatNumber(userGrowth.total_new_users)}</div>
                          <p className="text-xs text-muted-foreground">
                            Added in {selectedYear}
                          </p>
                        </CardContent>
                      </Card>
                      
                      <Card>
                        <CardHeader className="p-4 pb-2">
                          <CardTitle className="text-sm">Growth Rate</CardTitle>
                        </CardHeader>
                        <CardContent className="p-4 pt-0">
                          <div className="text-2xl font-bold">
                            {userGrowth.starting_user_count > 0 
                              ? `+${((userGrowth.total_new_users / userGrowth.starting_user_count) * 100).toFixed(1)}%` 
                              : 'N/A'}
                          </div>
                          <p className="text-xs text-muted-foreground">
                            Year over year
                          </p>
                        </CardContent>
                      </Card>
                      
                      <Card>
                        <CardHeader className="p-4 pb-2">
                          <CardTitle className="text-sm">Peak Month</CardTitle>
                        </CardHeader>
                        <CardContent className="p-4 pt-0">
                          {(() => {
                            const maxMonth = [...userGrowth.monthly_data].sort((a, b) => b.total - a.total)[0];
                            return (
                              <>
                                <div className="text-2xl font-bold">{maxMonth.month_name}</div>
                                <p className="text-xs text-muted-foreground">
                                  {maxMonth.total} new users
                                </p>
                              </>
                            );
                          })()}
                        </CardContent>
                      </Card>
                    </>
                  )}
                </div>
                
                <div className="h-80">
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
                          stroke="#FF8042"
                          strokeWidth={2}
                          dot={false}
                        />
                      </BarChart>
                    </ResponsiveContainer>
                  ) : (
                    <div className="flex items-center justify-center h-full">
                      <p className="text-muted-foreground">No growth data available for {selectedYear}</p>
                    </div>
                  )}
                </div>
              </CardContent>
            </Card>
          </TabsContent>
          
          {/* Demographics Tab */}
          <TabsContent value="demographics">
            <Card>
              <CardHeader className="flex flex-row justify-between items-center">
                <div>
                  <CardTitle>User Demographics</CardTitle>
                  <CardDescription>Distribution of users by various attributes</CardDescription>
                </div>
                <Button variant="outline" size="sm" onClick={() => handleExportCSV('demographics')}>
                  <Download className="h-4 w-4 mr-2" />
                  Export
                </Button>
              </CardHeader>
              <CardContent>
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 mb-6">
                  {demographics && (
                    <>
                      <Card>
                        <CardHeader className="p-4 pb-2">
                          <CardTitle className="text-sm flex items-center">
                            <Users className="h-4 w-4 mr-2" />
                            Gender Ratio
                          </CardTitle>
                        </CardHeader>
                        <CardContent className="p-4 pt-0">
                          {(() => {
                            const maleCount = demographics.genderDistribution.find(g => g.gender === 'Male')?.count || 0;
                            const femaleCount = demographics.genderDistribution.find(g => g.gender === 'Female')?.count || 0;
                            const total = demographics.genderDistribution.reduce((sum, item) => sum + item.count, 0);
                            
                            return (
                              <div className="flex items-center justify-between">
                                <div>
                                  <div className="font-medium">Male</div>
                                  <div>{maleCount} ({calculatePercentage(maleCount, total)})</div>
                                </div>
                                <div>
                                  <div className="font-medium">Female</div>
                                  <div>{femaleCount} ({calculatePercentage(femaleCount, total)})</div>
                                </div>
                              </div>
                            );
                          })()}
                        </CardContent>
                      </Card>
                      
                      <Card>
                        <CardHeader className="p-4 pb-2">
                          <CardTitle className="text-sm flex items-center">
                            <Activity className="h-4 w-4 mr-2" />
                            Age Distribution
                          </CardTitle>
                        </CardHeader>
                        <CardContent className="p-4 pt-0">
                          {(() => {
                            // Find largest age group
                            const largestAgeGroup = [...demographics.ageDistribution]
                              .sort((a, b) => b.count - a.count)[0];
                            
                            const totalWithAge = demographics.ageDistribution
                              .reduce((sum, item) => sum + item.count, 0);
                            
                            return (
                              <div>
                                <div className="font-medium">Largest Group</div>
                                <div>{largestAgeGroup.age_group} ({largestAgeGroup.count} users)</div>
                                <div className="text-xs text-muted-foreground mt-1">
                                  {demographics.usersMissingBirthdate} users missing birthdate
                                </div>
                              </div>
                            );
                          })()}
                        </CardContent>
                      </Card>
                      
                      <Card>
                        <CardHeader className="p-4 pb-2">
                          <CardTitle className="text-sm flex items-center">
                            <Dumbbell className="h-4 w-4 mr-2" />
                            Fitness Level
                          </CardTitle>
                        </CardHeader>
                        <CardContent className="p-4 pt-0">
                          {(() => {
                            // Find most common fitness level
                            const topFitnessLevel = [...demographics.fitnessLevelDistribution]
                              .sort((a, b) => b.count - a.count)[0];
                            
                            const total = demographics.fitnessLevelDistribution
                              .reduce((sum, item) => sum + item.count, 0);
                            
                            return (
                              <div>
                                <div className="font-medium">Most Common</div>
                                <div>{topFitnessLevel.fitness_level || 'Unspecified'}</div>
                                <div className="text-xs text-muted-foreground mt-1">
                                  {topFitnessLevel.count} users ({calculatePercentage(topFitnessLevel.count, total)})
                                </div>
                              </div>
                            );
                          })()}
                        </CardContent>
                      </Card>
                      
                      <Card>
                        <CardHeader className="p-4 pb-2">
                          <CardTitle className="text-sm flex items-center">
                            <Target className="h-4 w-4 mr-2" />
                            Fitness Goals
                          </CardTitle>
                        </CardHeader>
                        <CardContent className="p-4 pt-0">
                          {(() => {
                            // Find most common goal
                            const topGoal = [...demographics.goalTypeDistribution]
                              .sort((a, b) => b.count - a.count)[0];
                            
                            const total = demographics.goalTypeDistribution
                              .reduce((sum, item) => sum + item.count, 0);
                            
                            return (
                              <div>
                                <div className="font-medium">Most Common</div>
                                <div>{topGoal.goal_type?.replace('_', ' ') || 'Unspecified'}</div>
                                <div className="text-xs text-muted-foreground mt-1">
                                  {topGoal.count} users ({calculatePercentage(topGoal.count, total)})
                                </div>
                              </div>
                            );
                          })()}
                        </CardContent>
                      </Card>
                    </>
                  )}
                </div>
                
                <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                  {/* Gender Distribution */}
                  <div className="h-72">
                    <h3 className="text-sm font-medium mb-3">Gender Distribution</h3>
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
                            label={({gender, count, percent}) => `${gender}: ${(percent * 100).toFixed(0)}%`}
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
                        <p className="text-muted-foreground">No gender data available</p>
                      </div>
                    )}
                  </div>
                  
                  {/* Age Distribution */}
                  <div className="h-72">
                    <h3 className="text-sm font-medium mb-3">Age Distribution</h3>
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
                        <p className="text-muted-foreground">No age data available</p>
                      </div>
                    )}
                  </div>
                  
                  {/* Fitness Level Distribution */}
                  <div className="h-72">
                    <h3 className="text-sm font-medium mb-3">Fitness Level Distribution</h3>
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
                              `${fitness_level || 'Unspecified'}: ${(percent * 100).toFixed(0)}%`}
                          >
                            {demographics.fitnessLevelDistribution.map((entry, index) => (
                              <Cell key={`cell-${index}`} fill={COLORS[index % COLORS.length]} />
                            ))}
                          </Pie>
                          <Tooltip formatter={(value, name) => [`${value} users`, `Level: ${name || 'Unspecified'}`]} />
                          <Legend />
                        </PieChart>
                      </ResponsiveContainer>
                    ) : (
                      <div className="flex items-center justify-center h-full">
                        <p className="text-muted-foreground">No fitness level data available</p>
                      </div>
                    )}
                  </div>
                  
                  {/* Goal Type Distribution */}
                  <div className="h-72">
                    <h3 className="text-sm font-medium mb-3">Fitness Goal Distribution</h3>
                    {demographics?.goalTypeDistribution ? (
                      <ResponsiveContainer width="100%" height="100%">
                        <BarChart
                          data={demographics.goalTypeDistribution.map(item => ({
                            ...item,
                            goal_name: item.goal_type?.replace('_', ' ') || 'Unspecified'
                          }))}
                          margin={{ top: 20, right: 30, left: 20, bottom: 5 }}
                          layout="vertical"
                        >
                          <CartesianGrid strokeDasharray="3 3" />
                          <XAxis type="number" />
                          <YAxis type="category" dataKey="goal_name" width={100} />
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
                        <p className="text-muted-foreground">No goal data available</p>
                      </div>
                    )}
                  </div>
                </div>
              </CardContent>
            </Card>
          </TabsContent>
          
          {/* Attendance Tab */}
          <TabsContent value="attendance">
            <Card>
              <CardHeader className="flex flex-row justify-between items-center">
                <div>
                  <CardTitle>Gym Attendance Trends</CardTitle>
                  <CardDescription>Daily attendance records for the last {selectedDays} days</CardDescription>
                </div>
                <Button variant="outline" size="sm" onClick={() => handleExportCSV('attendance')}>
                  <Download className="h-4 w-4 mr-2" />
                  Export
                </Button>
              </CardHeader>
              <CardContent>
                <div className="grid grid-cols-1 md:grid-cols-4 gap-4 mb-6">
                  {attendanceTrends && (
                    <>
                      <Card>
                        <CardHeader className="p-4 pb-2">
                          <CardTitle className="text-sm flex items-center">
                            <Calendar className="h-4 w-4 mr-2" />
                            Average Daily
                          </CardTitle>
                        </CardHeader>
                        <CardContent className="p-4 pt-0">
                          {(() => {
                            const totalAttendance = attendanceTrends.attendance.reduce((sum, day) => sum + day.total, 0);
                            const average = totalAttendance / attendanceTrends.attendance.length;
                            
                            return (
                              <div className="text-2xl font-bold">{Math.round(average)}</div>
                            );
                          })()}
                        </CardContent>
                      </Card>
                      
                      <Card>
                        <CardHeader className="p-4 pb-2">
                          <CardTitle className="text-sm flex items-center">
                            <Heart className="h-4 w-4 mr-2" />
                            Peak Day
                          </CardTitle>
                        </CardHeader>
                        <CardContent className="p-4 pt-0">
                          {(() => {
                            // Find day with highest attendance
                            const peakDay = [...attendanceTrends.attendance].sort((a, b) => b.total - a.total)[0];
                            
                            return (
                              <>
                                <div className="text-2xl font-bold">{peakDay.total}</div>
                                <p className="text-xs text-muted-foreground">
                                  on {format(new Date(peakDay.date), 'EEEE, MMM d')}
                                </p>
                              </>
                            );
                          })()}
                        </CardContent>
                      </Card>
                      
                      <Card>
                        <CardHeader className="p-4 pb-2">
                          <CardTitle className="text-sm flex items-center">
                            <Activity className="h-4 w-4 mr-2" />
                            Total Visits
                          </CardTitle>
                        </CardHeader>
                        <CardContent className="p-4 pt-0">
                          {(() => {
                            const totalAttendance = attendanceTrends.attendance.reduce((sum, day) => sum + day.total, 0);
                            
                            return (
                              <>
                                <div className="text-2xl font-bold">{formatNumber(totalAttendance)}</div>
                                <p className="text-xs text-muted-foreground">
                                  Past {selectedDays} days
                                </p>
                              </>
                            );
                          })()}
                        </CardContent>
                      </Card>
                      
                      <Card>
                        <CardHeader className="p-4 pb-2">
                          <CardTitle className="text-sm flex items-center">
                            <Dumbbell className="h-4 w-4 mr-2" />
                            Busiest Gym
                          </CardTitle>
                        </CardHeader>
                        <CardContent className="p-4 pt-0">
                          {(() => {
                            // Calculate total for each gym
                            const gymTotals = {};
                            attendanceTrends.gyms.forEach(gym => {
                              gymTotals[gym.id] = attendanceTrends.attendance.reduce(
                                (sum, day) => sum + (day[gym.key] || 0), 0
                              );
                            });
                            
                            // Find busiest gym
                            let busiestGymId = null;
                            let maxAttendance = 0;
                            
                            Object.keys(gymTotals).forEach(gymId => {
                              if (gymTotals[gymId] > maxAttendance) {
                                maxAttendance = gymTotals[gymId];
                                busiestGymId = gymId;
                              }
                            });
                            
                            const busiestGym = attendanceTrends.gyms.find(g => g.id === parseInt(busiestGymId));
                            
                            return busiestGym ? (
                              <>
                                <div className="text-lg font-medium truncate">{busiestGym.name}</div>
                                <p className="text-xs text-muted-foreground">
                                  {maxAttendance} visits
                                </p>
                              </>
                            ) : (
                              <div>No data available</div>
                            );
                          })()}
                        </CardContent>
                      </Card>
                    </>
                  )}
                </div>
                
                <div className="h-80">
                  {attendanceTrends ? (
                    <ResponsiveContainer width="100%" height="100%">
                      <LineChart
                        data={attendanceTrends.attendance}
                        margin={{ top: 20, right: 30, left: 20, bottom: 30 }}
                      >
                        <CartesianGrid strokeDasharray="3 3" />
                        <XAxis 
                          dataKey="date" 
                          tickFormatter={(date) => format(new Date(date), 'MMM d')}
                        />
                        <YAxis />
                        <Tooltip 
                          labelFormatter={(date) => format(new Date(date), 'EEEE, MMMM d, yyyy')}
                        />
                        <Legend />
                        <Line
                          type="monotone"
                          dataKey="total"
                          name="Total Attendance"
                          stroke="#8884d8"
                          strokeWidth={2}
                          dot={false}
                          activeDot={{ r: 8 }}
                        />
                        {attendanceTrends.gyms.map((gym, index) => (
                          <Line
                            key={gym.id}
                            type="monotone"
                            dataKey={gym.key}
                            name={gym.name}
                            stroke={COLORS[index % COLORS.length]}
                            dot={false}
                          />
                        ))}
                      </LineChart>
                    </ResponsiveContainer>
                  ) : (
                    <div className="flex items-center justify-center h-full">
                      <p className="text-muted-foreground">No attendance data available</p>
                    </div>
                  )}
                </div>
              </CardContent>
            </Card>
          </TabsContent>
        </Tabs>
      </div>
    </DashboardLayout>
  );
};

export default UserAnalyticsPage;