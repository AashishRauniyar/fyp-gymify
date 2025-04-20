import React, { useState, useEffect } from 'react';
import DashboardLayout from '@/components/layout/DashboardLayout';
import { 
  Card, 
  CardContent, 
  CardDescription, 
  CardHeader, 
  CardTitle 
} from '@/components/ui/card';
import { 
  Table, 
  TableBody, 
  TableCell, 
  TableHead, 
  TableHeader, 
  TableRow 
} from '@/components/ui/table';
import { Input } from '@/components/ui/input';
import { Button } from '@/components/ui/button';
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
  DropdownMenuCheckboxItem,
  DropdownMenuRadioGroup,
  DropdownMenuRadioItem,
  DropdownMenuSub,
  DropdownMenuSubContent,
  DropdownMenuSubTrigger,
} from '@/components/ui/dropdown-menu';
import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar';
import { Search, Plus, MoreHorizontal, Edit, Trash, Filter, User, Calendar, Scale, CreditCard, Building } from 'lucide-react';
import { Badge } from '@/components/ui/badge';
import { format } from 'date-fns';
import { Role } from '@/types';
import { userInstance } from '@/network/axios'; // Import axios instance
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog";
import {
  Tabs,
  TabsContent,
  TabsList,
  TabsTrigger,
} from "@/components/ui/tabs";
import {
  Form,
  FormControl,
  FormDescription,
  FormField,
  FormItem,
  FormLabel,
  FormMessage,
} from "@/components/ui/form";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { Checkbox } from "@/components/ui/checkbox";
import { Textarea } from "@/components/ui/textarea";
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer } from 'recharts';
import RegisterUserDialog from '@/components/userComponents/RegisteruserDialogue';

const UsersPage = () => {
  const [searchTerm, setSearchTerm] = useState('');
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [selectedUser, setSelectedUser] = useState(null);
  const [userDetails, setUserDetails] = useState(null);
  const [membershipDetails, setMembershipDetails] = useState([]);
  const [attendanceHistory, setAttendanceHistory] = useState([]);
  const [weightProgress, setWeightProgress] = useState([]);
  const [showDeleteConfirm, setShowDeleteConfirm] = useState(false);
  const [deleteUserId, setDeleteUserId] = useState(null);
  const [showUserDialog, setShowUserDialog] = useState(false);
  const [isEditMode, setIsEditMode] = useState(false);
  const [formData, setFormData] = useState({
    full_name: '',
    email: '',
    phone_number: '',
    role: '',
    address: '',
    fitness_level: '',
    goal_type: '',
    allergies: '',
    card_number: '',
    verified: false
  });
  const [originalData, setOriginalData] = useState({});
  // Sorting and filtering state
  const [sortField, setSortField] = useState('user_name');
  const [sortDirection, setSortDirection] = useState('asc');
  const [roleFilter, setRoleFilter] = useState('all');

  useEffect(() => {
    fetchUsers();
  }, []);

  const fetchUsers = async () => {
    try {
      const response = await userInstance.get('/admin/users');
      setUsers(response.data.data);
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  const fetchUserDetails = async (userId) => {
    try {
      const response = await userInstance.get(`/admin/users/${userId}`);
      setUserDetails(response.data.data);
      
      // Populate form data for editing
      if (response.data.data) {
        const userData = response.data.data;
        console.log('User data from API:', userData);
        
        const initialFormData = {
          full_name: userData.full_name || '',
          email: userData.email || '',
          phone_number: userData.phone_number || '',
          role: userData.role || '',
          address: userData.address || '',
          fitness_level: userData.fitness_level || '',
          goal_type: userData.goal_type || '',
          allergies: userData.allergies || '',
          card_number: userData.card_number || '',
          verified: userData.verified || false
        };
        
        setFormData(initialFormData);
        setOriginalData(initialFormData); // Store original data for comparison
      }
    } catch (err) {
      console.error('Error fetching user details:', err);
    }
  };

  const fetchMembershipDetails = async (userId) => {
    try {
      const response = await userInstance.get(`/admin/users/${userId}/membership`);
      setMembershipDetails(response.data.data);
    } catch (err) {
      console.error('Error fetching membership details:', err);
    }
  };

  const fetchAttendanceHistory = async (userId) => {
    try {
      const response = await userInstance.get(`/admin/users/${userId}/attendance`);
      setAttendanceHistory(response.data.data);
    } catch (err) {
      console.error('Error fetching attendance history:', err);
    }
  };

  const fetchWeightProgress = async (userId) => {
    try {
      const response = await userInstance.get(`/admin/users/${userId}/weight-progress`);
      setWeightProgress(response.data.data);
    } catch (err) {
      console.error('Error fetching weight progress:', err);
    }
  };

  const handleViewUser = async (user) => {
    setSelectedUser(user);
    await fetchUserDetails(user.user_id);
    await fetchMembershipDetails(user.user_id);
    await fetchAttendanceHistory(user.user_id);
    await fetchWeightProgress(user.user_id);
    setShowUserDialog(true);
    setIsEditMode(false);
  };

  const handleEditUser = async (user) => {
    setSelectedUser(user);
    await fetchUserDetails(user.user_id);
    setShowUserDialog(true);
    setIsEditMode(true);
  };

  const handleInputChange = (e) => {
    const { name, value, type, checked } = e.target;
    setFormData({
      ...formData,
      [name]: type === 'checkbox' ? checked : value
    });
  };

  const handleSelectChange = (name, value) => {
    setFormData({
      ...formData,
      [name]: value
    });
  };

  const handleUpdateUser = async () => {
    try {
      // Create an object with only the changed fields to avoid overwriting other fields
      const changedFields = {};
      
      // Compare current form data with original data to identify changes
      Object.keys(formData).forEach(key => {
        // Include the field if it's different from original or if it's the verified field
        if (formData[key] !== originalData[key] || key === 'verified') {
          // Only include non-empty values (except for boolean fields)
          if (formData[key] !== '' || typeof formData[key] === 'boolean') {
            changedFields[key] = formData[key];
          }
        }
      });
      
      console.log('Original data:', originalData);
      console.log('Form data:', formData);
      console.log('Updating user with changed fields:', changedFields);
      
      // Only make the API call if there are changes
      if (Object.keys(changedFields).length > 0) {
        await userInstance.put(`/admin/users/${selectedUser.user_id}`, changedFields);
        // Refresh users list after update
        fetchUsers();
      } else {
        console.log('No changes detected');
      }
      
      // Close the dialog
      setShowUserDialog(false);
    } catch (err) {
      console.error('Error updating user:', err);
      setError(err.message);
    }
  };

  const handleDelete = async () => {
    try {
      await userInstance.delete(`/admin/users/${deleteUserId}`);
      setUsers(prevUsers => prevUsers.filter(user => user.user_id !== deleteUserId));
      setShowDeleteConfirm(false);
    } catch (err) {
      setError(err.message);
    }
  };

  const filteredUsers = users
    .filter(user => 
      // Text search filter
      (user.user_name?.toLowerCase().includes(searchTerm.toLowerCase()) ||
      user.user_id.toString().includes(searchTerm.toLowerCase()) ||
      user.role?.toLowerCase().includes(searchTerm.toLowerCase()) ||
      user.email?.toLowerCase().includes(searchTerm.toLowerCase())) &&
      // Role filter
      (roleFilter === 'all' || user.role?.toLowerCase() === roleFilter.toLowerCase())
    )
    // Sort based on sortField and sortDirection
    .sort((a, b) => {
      // Default to comparing user_name if sortField doesn't exist
      const fieldA = a[sortField] || '';
      const fieldB = b[sortField] || '';
      
      // Handle string comparison
      if (typeof fieldA === 'string' && typeof fieldB === 'string') {
        return sortDirection === 'asc' 
          ? fieldA.localeCompare(fieldB)
          : fieldB.localeCompare(fieldA);
      }
      
      // Handle number comparison
      return sortDirection === 'asc' 
        ? fieldA - fieldB
        : fieldB - fieldA;
    });

  const getRoleBadgeVariant = (role) => {
    switch (role) {
      case 'Admin':
      case 'ADMIN':
        return 'destructive'; // Bright red for admin
      case 'Trainer':
      case 'TRAINER':
        return 'outline'; // Outlined for trainer
      case 'Member':
      case 'MEMBER':
        return 'secondary'; // Gray for regular members
      default:
        return 'secondary';
    }
  };

  const getRoleBackground = (role) => {
    switch (role) {
      case 'Admin':
      case 'ADMIN':
        return 'bg-red-600'; // Light red background for admin
      case 'Trainer':
      case 'TRAINER':
        return 'bg-blue-100'; // Light blue background for trainer
      case 'Member':
      case 'MEMBER':
        return 'bg-gray-100'; // Light gray background for members
      default:
        return 'bg-gray-100';
    }
  };

  // Get status badge variant for membership status
  const getStatusBadgeVariant = (status) => {
    switch (status) {
      case 'Active':
      case 'ACTIVE':
        return 'success';
      case 'Pending':
      case 'PENDING':
        return 'warning';
      case 'Expired':
      case 'EXPIRED':
        return 'destructive';
      case 'Cancelled':
      case 'CANCELLED':
        return 'outline';
      default:
        return 'secondary';
    }
  };

  if (loading) return <DashboardLayout><p className="p-6">Loading users...</p></DashboardLayout>;
  if (error) return <DashboardLayout><p className="p-6 text-red-500">Error: {error}</p></DashboardLayout>;

  return (
    <DashboardLayout>
      <div className="space-y-6 p-6">
        <div className="flex justify-between items-center">
          <h1 className="text-2xl font-bold tracking-tight">Users Management</h1>
          <RegisterUserDialog onSuccess={fetchUsers} />
          
        </div>

        {/* <div className="flex justify-between items-center">
      <h1 className="text-2xl font-bold tracking-tight">Users Management</h1>
    </div> */}

        <Card>
          <CardHeader className="pb-3">
            <CardTitle>All Users</CardTitle>
            <CardDescription>Manage users and their roles</CardDescription>
          </CardHeader>
          <CardContent>
            <div className="flex items-center justify-between mb-4">
              <div className="relative w-full max-w-sm">
                <Search className="absolute left-2.5 top-2.5 h-4 w-4 text-muted-foreground" />
                <Input
                  placeholder="Search users..."
                  className="pl-8"
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                />
              </div>
              <div className="flex items-center gap-2">
                <DropdownMenu>
                  <DropdownMenuTrigger asChild>
                    <Button variant="outline" size="sm" className="flex items-center gap-2">
                      <Filter className="h-4 w-4" />
                      Filter
                    </Button>
                  </DropdownMenuTrigger>
                  <DropdownMenuContent align="end" className="w-56">
                    <DropdownMenuLabel>Filter by Role</DropdownMenuLabel>
                    <DropdownMenuSeparator />
                    <DropdownMenuRadioGroup value={roleFilter} onValueChange={setRoleFilter}>
                      <DropdownMenuRadioItem value="all">All Roles</DropdownMenuRadioItem>
                      <DropdownMenuRadioItem value="admin">Admin</DropdownMenuRadioItem>
                      <DropdownMenuRadioItem value="trainer">Trainer</DropdownMenuRadioItem>
                      <DropdownMenuRadioItem value="member">Member</DropdownMenuRadioItem>
                    </DropdownMenuRadioGroup>
                    <DropdownMenuSeparator />
                    <DropdownMenuLabel>Sort By</DropdownMenuLabel>
                    <DropdownMenuItem onClick={() => {setSortField('user_name'); setSortDirection('asc');}}>
                      Name (A-Z)
                    </DropdownMenuItem>
                    <DropdownMenuItem onClick={() => {setSortField('user_name'); setSortDirection('desc');}}>
                      Name (Z-A)
                    </DropdownMenuItem>
                    <DropdownMenuItem onClick={() => {setSortField('created_at'); setSortDirection('desc');}}>
                      Newest First
                    </DropdownMenuItem>
                    <DropdownMenuItem onClick={() => {setSortField('created_at'); setSortDirection('asc');}}>
                      Oldest First
                    </DropdownMenuItem>
                  </DropdownMenuContent>
                </DropdownMenu>
              </div>
            </div>

            <div className="rounded-md border">
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead>User</TableHead>
                    <TableHead>Email</TableHead>
                    <TableHead>Role</TableHead>
                    <TableHead>Card Number</TableHead>
                    <TableHead>Joined</TableHead>
                    <TableHead>Verified</TableHead>
                    <TableHead className="text-right">Actions</TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {filteredUsers.map(user => (
                    <TableRow key={user.user_id}>
                      <TableCell className="font-medium">
                        <div className="flex items-center gap-3">
                          <Avatar className="h-8 w-8">
                            <AvatarImage src={user.profile_image} alt={user.user_name} />
                            <AvatarFallback>{user.user_name?.substring(0, 2).toUpperCase()}</AvatarFallback>
                          </Avatar>
                          <div>
                            <div className="font-medium">{user.user_name}</div>
                            <div className="text-xs text-muted-foreground">{user.user_id}</div>
                          </div>
                        </div>
                      </TableCell>
                      <TableCell>{user.email}</TableCell>
                      <TableCell>
                        <Badge 
                          variant={getRoleBadgeVariant(user.role)} 
                          className={`font-semibold px-3 py-1 ${getRoleBackground(user.role)}`}
                        >
                          {user.role}
                        </Badge>
                      </TableCell>
                      <TableCell>{user.card_number || 'N/A'}</TableCell>
                      <TableCell>
                        {user.created_at ? format(new Date(user.created_at), 'MMM d, yyyy') : 'N/A'}
                      </TableCell>
                      <TableCell>{user.verified ? 'Yes' : 'No'}</TableCell>
                      <TableCell className="text-right">
                        <DropdownMenu>
                          <DropdownMenuTrigger asChild>
                            <Button variant="ghost" size="icon">
                              <MoreHorizontal className="h-4 w-4" />
                              <span className="sr-only">Actions</span>
                            </Button>
                          </DropdownMenuTrigger>
                          <DropdownMenuContent align="end">
                            <DropdownMenuLabel>Actions</DropdownMenuLabel>
                            <DropdownMenuItem onClick={() => handleViewUser(user)}>
                              <User className="mr-2 h-4 w-4" />
                              View Details
                            </DropdownMenuItem>
                            <DropdownMenuItem onClick={() => handleEditUser(user)}>
                              <Edit className="mr-2 h-4 w-4" />
                              Edit
                            </DropdownMenuItem>
                            <DropdownMenuSeparator />
                            <DropdownMenuItem
                              className="text-destructive"
                              onClick={() => { setDeleteUserId(user.user_id); setShowDeleteConfirm(true); }}
                            >
                              <Trash className="mr-2 h-4 w-4" />
                              Delete
                            </DropdownMenuItem>
                          </DropdownMenuContent>
                        </DropdownMenu>
                      </TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            </div>
          </CardContent>
        </Card>
      </div>

      {/* User Details Dialog */}
      {showUserDialog && userDetails && (
        <Dialog open={showUserDialog} onOpenChange={setShowUserDialog}>
          <DialogContent className="max-w-4xl">
            <DialogHeader>
              <DialogTitle>
                {isEditMode ? 'Edit User' : 'User Details'} - {userDetails.user_name}
              </DialogTitle>
              <DialogDescription>
                {isEditMode 
                  ? 'Update user information and settings'
                  : `User ID: ${userDetails.user_id}`
                }
              </DialogDescription>
            </DialogHeader>

            <Tabs defaultValue="info">
              <TabsList className="grid w-full grid-cols-4">
                <TabsTrigger value="info">Information</TabsTrigger>
                <TabsTrigger value="membership">Membership</TabsTrigger>
                <TabsTrigger value="attendance">Attendance</TabsTrigger>
                <TabsTrigger value="weight">Weight Progress</TabsTrigger>
              </TabsList>

              {/* User Info Tab */}
              <TabsContent value="info">
                {isEditMode ? (
                  <div className="grid gap-4 py-4">
                    <div className="grid grid-cols-2 gap-4">
                      <div className="space-y-2">
                        <label className="text-sm font-medium">Full Name</label>
                        <Input 
                          name="full_name" 
                          value={formData.full_name} 
                          onChange={handleInputChange} 
                        />
                      </div>
                      <div className="space-y-2">
                        <label className="text-sm font-medium">Email</label>
                        <Input 
                          name="email" 
                          value={formData.email} 
                          onChange={handleInputChange} 
                        />
                      </div>
                    </div>
                    <div className="grid grid-cols-2 gap-4">
                      <div className="space-y-2">
                        <label className="text-sm font-medium">Phone Number</label>
                        <Input 
                          name="phone_number" 
                          value={formData.phone_number} 
                          onChange={handleInputChange} 
                        />
                      </div>
                      <div className="space-y-2">
                        <label className="text-sm font-medium">Role</label>
                        <Select 
                          value={formData.role} 
                          onValueChange={(value) => handleSelectChange('role', value)}
                        >
                          <SelectTrigger>
                            <SelectValue placeholder="Select role" />
                          </SelectTrigger>
                          <SelectContent>
                            <SelectItem value="Admin">Admin</SelectItem>
                            <SelectItem value="Trainer">Trainer</SelectItem>
                            <SelectItem value="Member">Member</SelectItem>
                          </SelectContent>
                        </Select>
                      </div>
                    </div>
                    <div className="space-y-2">
                      <label className="text-sm font-medium">Address</label>
                      <Textarea 
                        name="address" 
                        value={formData.address} 
                        onChange={handleInputChange}
                      />
                    </div>
                    <div className="grid grid-cols-2 gap-4">
                      <div className="space-y-2">
                        <label className="text-sm font-medium">Fitness Level</label>
                        <Select 
                          value={formData.fitness_level} 
                          onValueChange={(value) => handleSelectChange('fitness_level', value)}
                        >
                          <SelectTrigger>
                            <SelectValue placeholder="Select fitness level" />
                          </SelectTrigger>
                          <SelectContent>
                            <SelectItem value="Beginner">Beginner</SelectItem>
                            <SelectItem value="Intermediate">Intermediate</SelectItem>
                            <SelectItem value="Advanced">Advanced</SelectItem>
                            <SelectItem value="Athlete">Athlete</SelectItem>
                          </SelectContent>
                        </Select>
                      </div>
                      <div className="space-y-2">
                        <label className="text-sm font-medium">Goal Type</label>
                        <Select 
                          value={formData.goal_type} 
                          onValueChange={(value) => handleSelectChange('goal_type', value)}
                        >
                          <SelectTrigger>
                            <SelectValue placeholder="Select goal type" />
                          </SelectTrigger>
                          <SelectContent>
                            <SelectItem value="Weight_Loss">Weight Loss</SelectItem>
                            <SelectItem value="Muscle_Gain">Muscle Gain</SelectItem>
                            <SelectItem value="Endurance">Endurance</SelectItem>
                            <SelectItem value="Maintenance">Maintenance</SelectItem>
                            <SelectItem value="Flexibility">Flexibility</SelectItem>
                          </SelectContent>
                        </Select>
                      </div>
                    </div>
                    <div className="space-y-2">
                      <label className="text-sm font-medium">Allergies</label>
                      <Textarea 
                        name="allergies" 
                        value={formData.allergies} 
                        onChange={handleInputChange}
                      />
                    </div>
                    <div className="space-y-2">
                      <label className="text-sm font-medium">Card Number</label>
                      <Input 
                        name="card_number" 
                        value={formData.card_number} 
                        onChange={handleInputChange}
                        placeholder="Enter card number (optional)"
                      />
                    </div>
                    <div className="flex items-center space-x-2">
                      <Checkbox 
                        id="verified" 
                        name="verified"
                        checked={formData.verified}
                        onCheckedChange={(checked) => setFormData({...formData, verified: checked})}
                      />
                      <label htmlFor="verified" className="text-sm font-medium">
                        Account Verified
                      </label>
                    </div>
                  </div>
                ) : (
                  <div className="grid grid-cols-2 gap-4 py-4">
                    <div>
                      <h3 className="font-medium">Personal Information</h3>
                      <dl className="mt-2 space-y-2">
                        <div>
                          <dt className="text-sm text-muted-foreground">Full Name</dt>
                          <dd>{userDetails.full_name || 'Not provided'}</dd>
                        </div>
                        <div>
                          <dt className="text-sm text-muted-foreground">Email</dt>
                          <dd>{userDetails.email}</dd>
                        </div>
                        <div>
                          <dt className="text-sm text-muted-foreground">Phone</dt>
                          <dd>{userDetails.phone_number || 'Not provided'}</dd>
                        </div>
                        <div>
                          <dt className="text-sm text-muted-foreground">Address</dt>
                          <dd>{userDetails.address || 'Not provided'}</dd>
                        </div>
                        <div>
                          <dt className="text-sm text-muted-foreground">Gender</dt>
                          <dd>{userDetails.gender || 'Not provided'}</dd>
                        </div>
                        <div>
                          <dt className="text-sm text-muted-foreground">Birthdate</dt>
                          <dd>{userDetails.birthdate ? format(new Date(userDetails.birthdate), 'MMM d, yyyy') : 'Not provided'}</dd>
                        </div>
                      </dl>
                    </div>
                    <div>
                      <h3 className="font-medium">Fitness Information</h3>
                      <dl className="mt-2 space-y-2">
                        <div>
                          <dt className="text-sm text-muted-foreground">Fitness Level</dt>
                          <dd>{userDetails.fitness_level || 'Not provided'}</dd>
                        </div>
                        <div>
                          <dt className="text-sm text-muted-foreground">Goal Type</dt>
                          <dd>{userDetails.goal_type || 'Not provided'}</dd>
                        </div>
                        <div>
                          <dt className="text-sm text-muted-foreground">Current Weight</dt>
                          <dd>{userDetails.current_weight ? `${userDetails.current_weight} kg` : 'Not provided'}</dd>
                        </div>
                        <div>
                          <dt className="text-sm text-muted-foreground">Height</dt>
                          <dd>{userDetails.height ? `${userDetails.height} cm` : 'Not provided'}</dd>
                        </div>
                        <div>
                          <dt className="text-sm text-muted-foreground">Calorie Goals</dt>
                          <dd>{userDetails.calorie_goals || 'Not provided'}</dd>
                        </div>
                        <div>
                          <dt className="text-sm text-muted-foreground">Allergies</dt>
                          <dd>{userDetails.allergies || 'None'}</dd>
                        </div>
                        <div>
                          <dt className="text-sm text-muted-foreground">Card Number</dt>
                          <dd>{userDetails.card_number || 'Not provided'}</dd>
                        </div>
                      </dl>
                    </div>
                  </div>
                )}
              </TabsContent>

              {/* Membership Tab */}
              <TabsContent value="membership">
                {membershipDetails.length > 0 ? (
                  <div className="space-y-4">
                    <h3 className="font-medium">Current Membership</h3>
                    <div className="max-h-80 overflow-y-auto border rounded">
                      <Table>
                        <TableHeader className="sticky top-0 bg-white z-10">
                          <TableRow>
                            <TableHead>Plan</TableHead>
                            <TableHead>Start Date</TableHead>
                            <TableHead>End Date</TableHead>
                            <TableHead>Status</TableHead>
                            <TableHead>Amount Paid</TableHead>
                            <TableHead>Payment Method</TableHead>
                          </TableRow>
                        </TableHeader>
                        <TableBody>
                          {membershipDetails.map(membership => {
                            // Find the payment information if available
                            const payment = membership.payments && membership.payments.length > 0 
                              ? membership.payments[0] 
                              : null;
                              
                            return (
                              <TableRow key={membership.membership_id}>
                                <TableCell className="font-medium">
                                  {membership.membership_plan?.plan_type || 'Unknown'}
                                </TableCell>
                                <TableCell>
                                  {membership.start_date 
                                    ? format(new Date(membership.start_date), 'MMM d, yyyy') 
                                    : 'N/A'}
                                </TableCell>
                                <TableCell>
                                  {membership.end_date 
                                    ? format(new Date(membership.end_date), 'MMM d, yyyy') 
                                    : 'N/A'}
                                </TableCell>
                                <TableCell>
                                  <Badge variant={getStatusBadgeVariant(membership.status)}>
                                    {membership.status}
                                  </Badge>
                                </TableCell>
                                <TableCell>
                                  {payment && payment.price 
                                    ? `NPR ${parseFloat(payment.price).toFixed(2)}` 
                                    : 'N/A'}
                                </TableCell>
                                <TableCell>
                                  {payment ? payment.payment_method : 'N/A'}
                                </TableCell>
                              </TableRow>
                            );
                          })}
                        </TableBody>
                      </Table>
                    </div>
                    
                    {/* Membership Details Summary */}
                    {membershipDetails.length > 0 && membershipDetails[0].membership_plan && (
                      <Card>
                        <CardHeader className="pb-2">
                          <CardTitle className="text-lg">Membership Details</CardTitle>
                        </CardHeader>
                        <CardContent>
                          <div className="grid grid-cols-2 gap-4">
                            <div>
                              <p className="text-sm font-medium text-muted-foreground">Current Plan</p>
                              <p className="text-lg font-semibold">
                                {membershipDetails[0].membership_plan.plan_type || 'Unknown'}
                              </p>
                            </div>
                            <div>
                              <p className="text-sm font-medium text-muted-foreground">Status</p>
                              <Badge variant={getStatusBadgeVariant(membershipDetails[0].status)}>
                                {membershipDetails[0].status}
                              </Badge>
                            </div>
                            <div>
                              <p className="text-sm font-medium text-muted-foreground">Duration</p>
                              <p>{membershipDetails[0].membership_plan.duration || 'N/A'} months</p>
                            </div>
                            <div>
                              <p className="text-sm font-medium text-muted-foreground">Description</p>
                              <p>{membershipDetails[0].membership_plan.description || 'No description available'}</p>
                            </div>
                          </div>
                        </CardContent>
                      </Card>
                    )}
                  </div>
                ) : (
                  <div className="py-8 text-center">
                    <p>No membership information available</p>
                  </div>
                )}
              </TabsContent>

              {/* Attendance Tab */}
              <TabsContent value="attendance">
                {attendanceHistory.length > 0 ? (
                  <div className="space-y-4">
                    <div className="flex justify-between items-center">
                      <h3 className="font-medium">Attendance History</h3>
                      <div className="flex space-x-2">
                        <Input type="date" className="w-40" placeholder="Start date" />
                        <Input type="date" className="w-40" placeholder="End date" />
                        <Button variant="outline" size="sm">Filter</Button>
                      </div>
                    </div>
                    <div className="max-h-80 overflow-y-auto border rounded">
                      <Table>
                        <TableHeader className="sticky top-0 bg-white z-10">
                          <TableRow>
                            <TableHead>Date</TableHead>
                            <TableHead>Check-in Time</TableHead>
                            <TableHead>Check-out Time</TableHead>
                            <TableHead>Duration</TableHead>
                            <TableHead>Gym</TableHead>
                          </TableRow>
                        </TableHeader>
                        <TableBody>
                          {attendanceHistory.map(record => (
                            <TableRow key={record.attendance_id}>
                              <TableCell>
                                {record.attendance_date 
                                  ? format(new Date(record.attendance_date), 'MMM d, yyyy') 
                                  : 'N/A'}
                              </TableCell>
                              <TableCell>
                                {record.check_in_time 
                                  ? format(new Date(record.check_in_time), 'h:mm a') 
                                  : 'N/A'}
                              </TableCell>
                              <TableCell>
                                {record.check_out_time 
                                  ? format(new Date(record.check_out_time), 'h:mm a') 
                                  : 'N/A'}
                              </TableCell>
                              <TableCell>
                                {record.check_in_time && record.check_out_time 
                                  ? `${Math.round((new Date(record.check_out_time) - new Date(record.check_in_time)) / (1000 * 60))} mins` 
                                  : 'N/A'}
                              </TableCell>
                              <TableCell>
                                {record.gym_id || 'Main Gym'}
                              </TableCell>
                            </TableRow>
                          ))}
                        </TableBody>
                      </Table>
                    </div>
                    
                    {/* Attendance Summary Card */}
                    <Card>
                      <CardHeader className="pb-2">
                        <CardTitle className="text-lg">Attendance Summary</CardTitle>
                      </CardHeader>
                      <CardContent>
                        <div className="grid grid-cols-3 gap-4">
                          <div>
                            <p className="text-sm font-medium text-muted-foreground">Total Visits</p>
                            <p className="text-2xl font-bold">{attendanceHistory.length}</p>
                          </div>
                          <div>
                            <p className="text-sm font-medium text-muted-foreground">This Month</p>
                            <p className="text-2xl font-bold">
                              {attendanceHistory.filter(record => {
                                const recordDate = new Date(record.attendance_date);
                                const now = new Date();
                                return recordDate.getMonth() === now.getMonth() && 
                                       recordDate.getFullYear() === now.getFullYear();
                              }).length}
                            </p>
                          </div>
                          <div>
                            <p className="text-sm font-medium text-muted-foreground">Last Visit</p>
                            <p className="text-lg font-semibold">
                              {attendanceHistory.length > 0 
                                ? format(new Date(attendanceHistory[0].attendance_date), 'MMM d, yyyy')
                                : 'N/A'}
                            </p>
                          </div>
                        </div>
                      </CardContent>
                    </Card>
                  </div>
                ) : (
                  <div className="py-8 text-center">
                    <p>No attendance records available</p>
                  </div>
                )}
              </TabsContent>

              {/* Weight Progress Tab */}
              <TabsContent value="weight">
                {weightProgress.length > 0 ? (
                  <div className="space-y-4">
                    <div className="flex justify-between items-center">
                      <h3 className="font-medium">Weight Progress</h3>
                      {weightProgress.length > 1 && (
                        <div className="text-sm">
                          <span className="font-semibold">
                            Total Change: 
                            <span className={
                              parseFloat(weightProgress[weightProgress.length - 1].weight) - parseFloat(weightProgress[0].weight) > 0 
                                ? " text-red-500" 
                                : parseFloat(weightProgress[weightProgress.length - 1].weight) - parseFloat(weightProgress[0].weight) < 0
                                  ? " text-green-500" 
                                  : " text-gray-500"
                            }>
                              {" "}{(parseFloat(weightProgress[weightProgress.length - 1].weight) - parseFloat(weightProgress[0].weight)).toFixed(1)} kg
                            </span>
                          </span>
                        </div>
                      )}
                    </div>
                    
                    <div className="h-60">
                      <ResponsiveContainer width="100%" height="100%">
                        <LineChart
                          data={weightProgress.map(log => ({
                            date: format(new Date(log.logged_at), 'MMM d'),
                            weight: parseFloat(log.weight)
                          }))}
                          margin={{ top: 5, right: 30, left: 20, bottom: 5 }}
                        >
                          <CartesianGrid strokeDasharray="3 3" />
                          <XAxis dataKey="date" />
                          <YAxis 
                            label={{ value: 'Weight (kg)', angle: -90, position: 'insideLeft' }} 
                            domain={['dataMin - 1', 'dataMax + 1']} // Add padding to y-axis
                          />
                          <Tooltip formatter={(value) => [`${value} kg`, 'Weight']} />
                          <Legend />
                          <Line 
                            type="monotone"
                            dataKey="weight"
                            stroke="#8884d8"
                            strokeWidth={2}
                            activeDot={{ r: 8 }}
                            dot={{ r: 4 }}
                          />
                        </LineChart>
                      </ResponsiveContainer>
                    </div>
                    
                    <div className="max-h-60 overflow-y-auto border rounded">
                      <Table>
                        <TableHeader className="sticky top-0 bg-white z-10">
                          <TableRow>
                            <TableHead>Date</TableHead>
                            <TableHead>Weight (kg)</TableHead>
                            <TableHead>Change</TableHead>
                            <TableHead>Notes</TableHead>
                          </TableRow>
                        </TableHeader>
                        <TableBody>
                          {weightProgress.map((log, index) => {
                            // Calculate weight change from previous entry
                            const prevWeight = index > 0 ? parseFloat(weightProgress[index - 1].weight) : null;
                            const currentWeight = parseFloat(log.weight);
                            const weightChange = prevWeight !== null ? (currentWeight - prevWeight).toFixed(1) : null;
                            
                            // Determine weight change display and color
                            let changeDisplay = 'Initial';
                            let changeColor = 'text-gray-500';
                            
                            if (weightChange !== null) {
                              if (parseFloat(weightChange) > 0) {
                                changeDisplay = `+${weightChange}`;
                                changeColor = 'text-red-500';
                              } else if (parseFloat(weightChange) < 0) {
                                changeDisplay = weightChange; // Already has minus sign
                                changeColor = 'text-green-500';
                              } else {
                                changeDisplay = '0';
                                changeColor = 'text-gray-500';
                              }
                            }
                            
                            return (
                              <TableRow key={log.id || index}>
                                <TableCell>
                                  {format(new Date(log.logged_at), 'MMM d, yyyy')}
                                </TableCell>
                                <TableCell className="font-medium">
                                  {currentWeight.toFixed(1)}
                                </TableCell>
                                <TableCell className={changeColor + " font-semibold"}>
                                  {changeDisplay}
                                </TableCell>
                                <TableCell>{log.notes || '-'}</TableCell>
                              </TableRow>
                            );
                          })}
                        </TableBody>
                      </Table>
                    </div>
                  </div>
                ) : (
                  <div className="py-8 text-center">
                    <p>No weight progress data available</p>
                  </div>
                )}
              </TabsContent>
            </Tabs>

            <DialogFooter>
              {isEditMode ? (
                <>
                  <Button 
                    variant="outline" 
                    onClick={() => setShowUserDialog(false)}
                  >
                    Cancel
                  </Button>
                  <Button onClick={handleUpdateUser}>Save Changes</Button>
                </>
              ) : (
                <Button onClick={() => setShowUserDialog(false)}>Close</Button>
              )}
            </DialogFooter>
          </DialogContent>
        </Dialog>
      )}

      {/* Delete Confirmation Dialog */}
      {showDeleteConfirm && (
        <Dialog open={showDeleteConfirm} onOpenChange={setShowDeleteConfirm}>
          <DialogContent className="sm:max-w-md">
            <DialogHeader>
              <DialogTitle>Confirm Deletion</DialogTitle>
              <DialogDescription>
                Are you sure you want to delete this user? This action cannot be undone.
              </DialogDescription>
            </DialogHeader>
            <div className="flex justify-end space-x-2">
              <Button variant="outline" onClick={() => setShowDeleteConfirm(false)}>
                Cancel
              </Button>
              <Button variant="destructive" onClick={handleDelete}>
                Delete
              </Button>
            </div>
          </DialogContent>
        </Dialog>
      )}
    </DashboardLayout>
  );
};

export default UsersPage;