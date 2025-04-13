import React, { useState, useEffect } from 'react';
import DashboardLayout from '@/components/layout/DashboardLayout';
import { 
  Card, CardContent, CardDescription, CardHeader, CardTitle, CardFooter 
} from '@/components/ui/card';
import { 
  Table, TableBody, TableCell, TableHead, TableHeader, TableRow 
} from '@/components/ui/table';
import { Input } from '@/components/ui/input';
import { Button } from '@/components/ui/button';
import {
  DropdownMenu, DropdownMenuContent, DropdownMenuItem, 
  DropdownMenuLabel, DropdownMenuSeparator, DropdownMenuTrigger
} from '@/components/ui/dropdown-menu';
import {
  Dialog, DialogContent, DialogDescription, DialogFooter,
  DialogHeader, DialogTitle, DialogTrigger
} from "@/components/ui/dialog";
import {
  Form, FormControl, FormDescription, FormField,
  FormItem, FormLabel, FormMessage
} from "@/components/ui/form";
import {
  Select, SelectContent, SelectItem, SelectTrigger, SelectValue
} from "@/components/ui/select";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar';
import { 
  Search, Plus, MoreHorizontal, Edit, Trash, RefreshCw, 
  Calendar, Users, Clipboard, AlertTriangle, CheckCircle, 
  HelpCircle, X, CreditCard
} from 'lucide-react';
import { Badge } from '@/components/ui/badge';
import { format } from 'date-fns';
import { useToast } from '@/components/ui/use-toast';
import { userInstance } from '@/network/axios';
import { 
  Pagination, PaginationContent, PaginationItem, 
  PaginationLink, PaginationNext, PaginationPrevious 
} from '@/components/ui/pagination';
import {
  AlertDialog, AlertDialogAction, AlertDialogCancel, AlertDialogContent,
  AlertDialogDescription, AlertDialogFooter, AlertDialogHeader,
  AlertDialogTitle, AlertDialogTrigger
} from "@/components/ui/alert-dialog";
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import * as z from 'zod';

// Define our enums and types
export const MembershipStatus = {
  Active: 'Active',
  Pending: 'Pending',
  Expired: 'Expired',
  Cancelled: 'Cancelled'
};

export const PlanType = {
  Monthly: 'Monthly',
  Quaterly: 'Quaterly',
  Yearly: 'Yearly'
};

// Form validation schema
// const membershipFormSchema = z.object({
//   user_id: z.string().min(1, "User is required"),
//   plan_id: z.string().min(1, "Plan is required"),
//   start_date: z.string().min(1, "Start date is required"),
//   end_date: z.string().min(1, "End date is required"),
//   status: z.string().min(1, "Status is required")
// });


const membershipFormSchema = z.object({
  user_id: z.string().min(1, "User is required"),
  plan_id: z.string().min(1, "Plan is required"),
  start_date: z.string().min(1, "Start date is required"),
  end_date: z.string().min(1, "End date is required"),
  status: z.string().min(1, "Status is required"),
  payment_method: z.string().min(1, "Payment method is required")
});

// Then update the form's defaultValues to include payment_method:


const MembershipsPage = () => {
  const { toast } = useToast();
  
  // State for memberships and filtering
  const [searchTerm, setSearchTerm] = useState('');
  const [memberships, setMemberships] = useState([]);
  const [filteredMemberships, setFilteredMemberships] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [statusFilter, setStatusFilter] = useState('all');
  const [planFilter, setPlanFilter] = useState('all');
  const [cardNumber, setCardNumber] = useState('');
  
  // State for pagination
  const [page, setPage] = useState(1);
  const [limit, setLimit] = useState(10);
  const [totalPages, setTotalPages] = useState(1);
  const [totalRecords, setTotalRecords] = useState(0);
  
  // State for dialogs
  const [showCreateDialog, setShowCreateDialog] = useState(false);
  const [showDetailsDialog, setShowDetailsDialog] = useState(false);
  const [showHistoryDialog, setShowHistoryDialog] = useState(false);
  const [showCardDialog, setShowCardDialog] = useState(false);
  const [isEditMode, setIsEditMode] = useState(false);
  const [selectedMembership, setSelectedMembership] = useState(null);
  const [membershipDetails, setMembershipDetails] = useState(null);
  const [membershipHistory, setMembershipHistory] = useState([]);
  
  // States for additional data
  const [users, setUsers] = useState([]);
  const [plans, setPlans] = useState([]);
  const [payments, setPayments] = useState([]);
  const [confirmDialog, setConfirmDialog] = useState({
    isOpen: false,
    title: '',
    message: '',
    onConfirm: null
  });

  const form = useForm({
    resolver: zodResolver(membershipFormSchema),
    defaultValues: {
      user_id: '',
      plan_id: '',
      start_date: format(new Date(), 'yyyy-MM-dd'),
      end_date: '',
      status: MembershipStatus.Pending,
      payment_method: ''
    }
  });
  

  // Form setup
  // const form = useForm({
  //   resolver: zodResolver(membershipFormSchema),
  //   defaultValues: {
  //     user_id: '',
  //     plan_id: '',
  //     start_date: '',
  //     end_date: '',
  //     status: MembershipStatus.Pending
  //   }
  // });

  // Fetch all data on component mount
  useEffect(() => {
    fetchMemberships();
    fetchUsers();
    fetchPlans();
  }, [page, limit]);

  // Apply filters and search
  useEffect(() => {
    if (!memberships.length) return;
    
    let filtered = [...memberships];
    
    // Apply status filter
    if (statusFilter !== 'all') {
      filtered = filtered.filter(membership => 
        membership.status?.toLowerCase() === statusFilter.toLowerCase()
      );
    }
    
    // Apply plan filter
    if (planFilter !== 'all') {
      filtered = filtered.filter(membership => 
        membership.membership_plan?.plan_type?.toLowerCase() === planFilter.toLowerCase()
      );
    }
    
    // Apply search term
    if (searchTerm) {
      filtered = filtered.filter(membership => 
        (membership.users?.full_name?.toLowerCase().includes(searchTerm.toLowerCase())) ||
        (membership.users?.email?.toLowerCase().includes(searchTerm.toLowerCase())) ||
        (membership.users?.user_name?.toLowerCase().includes(searchTerm.toLowerCase())) ||
        (membership.membership_plan?.plan_type?.toLowerCase().includes(searchTerm.toLowerCase())) ||
        (membership.status?.toLowerCase().includes(searchTerm.toLowerCase()))
      );
    }
    
    setFilteredMemberships(filtered);
  }, [memberships, searchTerm, statusFilter, planFilter]);

  // Fetch memberships with pagination
  const fetchMemberships = async () => {
    setLoading(true);
    try {
      const response = await userInstance.get('/admin/memberships', {
        params: { page, limit, status: statusFilter !== 'all' ? statusFilter : undefined }
      });
      
      console.log('Memberships API response:', response.data);
      
      const membershipData = response.data.data.memberships || response.data.data;
      const paginationData = response.data.data.pagination || { 
        pages: 1, 
        total: membershipData.length,
        current_page: 1,
        per_page: membershipData.length
      };
      
      setMemberships(membershipData);
      setFilteredMemberships(membershipData);
      setTotalPages(paginationData.pages);
      setTotalRecords(paginationData.total);
    } catch (err) {
      console.error('Error fetching memberships:', err);
      setError(err.message || 'Failed to load memberships');
      toast({
        title: "Error",
        description: "Failed to load memberships. Please try again.",
        variant: "destructive",
      });
    } finally {
      setLoading(false);
    }
  };

  // Fetch users for membership creation/editing
  const fetchUsers = async () => {
    try {
      const response = await userInstance.get('/admin/users');
      console.log('Users API response:', response.data);
      setUsers(response.data.data);
    } catch (err) {
      console.error('Error fetching users:', err);
      toast({
        title: "Error",
        description: "Failed to load users. Please try again.",
        variant: "destructive",
      });
    }
  };

  // Fetch membership plans
  const fetchPlans = async () => {
    try {
      const response = await userInstance.get('/admin/membership-plans');
      console.log('Plans API response:', response.data);
      setPlans(response.data.data);
    } catch (err) {
      console.error('Error fetching plans:', err);
      toast({
        title: "Error",
        description: "Failed to load membership plans. Please try again.",
        variant: "destructive",
      });
    }
  };

  // Fetch membership details
  const fetchMembershipDetails = async (membershipId) => {
    try {
      const response = await userInstance.get(`/admin/memberships/${membershipId}`);
      setMembershipDetails(response.data.data);
      return response.data.data;
    } catch (err) {
      console.error('Error fetching membership details:', err);
      toast({
        title: "Error",
        description: "Failed to load membership details.",
        variant: "destructive",
      });
      return null;
    }
  };

  // Fetch membership history
  const fetchMembershipHistory = async (membershipId) => {
    try {
      const response = await userInstance.get(`/admin/memberships/${membershipId}/changes`);
      setMembershipHistory(response.data.data);
    } catch (err) {
      console.error('Error fetching membership history:', err);
      toast({
        title: "Error",
        description: "Failed to load membership history.",
        variant: "destructive",
      });
    }
  };

  // // Handle membership creation
  // const handleCreateMembership = async (data) => {
  //   try {
  //     const payload = {
  //       user_id: parseInt(data.user_id),
  //       plan_id: parseInt(data.plan_id),
  //       start_date: data.start_date,
  //       end_date: data.end_date,
  //       status: data.status
  //     };

  //     const response = await userInstance.post('/admin/memberships', payload);
      
  //     toast({
  //       title: "Success",
  //       description: "Membership created successfully!",
  //       variant: "default",
  //     });
      
  //     fetchMemberships();
  //     setShowCreateDialog(false);
  //     form.reset();
  //   } catch (err) {
  //     console.error('Error creating membership:', err);
  //     toast({
  //       title: "Error",
  //       description: err.response?.data?.message || "Failed to create membership.",
  //       variant: "destructive",
  //     });
  //   }
  // };

  // Finally, update your handleCreateMembership function to include the payment_method:
const handleCreateMembership = async (data) => {
  try {
    const payload = {
      user_id: parseInt(data.user_id),
      plan_id: parseInt(data.plan_id),
      start_date: data.start_date,
      end_date: data.end_date,
      status: data.status,
      payment_method: data.payment_method
    };

    const response = await userInstance.post('/admin/memberships', payload);
    
    toast({
      title: "Success",
      description: "Membership created successfully!",
      variant: "default",
    });
    
    fetchMemberships();
    setShowCreateDialog(false);
    form.reset();
  } catch (err) {
    console.error('Error creating membership:', err);
    toast({
      title: "Error",
      description: err.response?.data?.message || "Failed to create membership.",
      variant: "destructive",
    });
  }
};

  // Handle membership update
  const handleUpdateMembership = async (data) => {
    try {
      const payload = {
        ...(data.plan_id && { plan_id: parseInt(data.plan_id) }),
        ...(data.start_date && { start_date: data.start_date }),
        ...(data.end_date && { end_date: data.end_date })
      };

      const response = await userInstance.put(`/admin/memberships/${selectedMembership.membership_id}`, payload);
      
      toast({
        title: "Success",
        description: "Membership updated successfully!",
        variant: "default",
      });
      
      fetchMemberships();
      setShowCreateDialog(false);
      setIsEditMode(false);
      form.reset();
    } catch (err) {
      console.error('Error updating membership:', err);
      toast({
        title: "Error",
        description: err.response?.data?.message || "Failed to update membership.",
        variant: "destructive",
      });
    }
  };

  // Handle membership approval
  const handleApproveMembership = async (membershipId) => {
    try {
      if (!cardNumber.trim()) {
        toast({
          title: "Validation Error",
          description: "Please provide a card number before approving.",
          variant: "destructive",
        });
        return;
      }
      
      const response = await userInstance.put(`/admin/approve/${membershipId}`, { card_number: cardNumber });
      
      // Update the local state
      const updatedMemberships = memberships.map(membership =>
        membership.membership_id === membershipId
          ? { ...membership, status: MembershipStatus.Active, users: { ...membership.users, card_number: cardNumber } }
          : membership
      );
      
      setMemberships(updatedMemberships);
      setCardNumber('');
      
      toast({
        title: "Success",
        description: "Membership approved successfully!",
        variant: "default",
      });
      
      fetchMemberships();
    } catch (error) {
      console.error('Error approving membership:', error);
      toast({
        title: "Error",
        description: error.response?.data?.message || "Failed to approve membership.",
        variant: "destructive",
      });
    }
  };

  // Handle membership status update
  const handleStatusUpdate = async (membershipId, newStatus) => {
    try {
      const response = await userInstance.patch(`/admin/memberships/${membershipId}/status`, {
        status: newStatus
      });
      
      toast({
        title: "Success",
        description: `Membership ${newStatus.toLowerCase()} successfully!`,
        variant: "default",
      });
      
      fetchMemberships();
    } catch (err) {
      console.error('Error updating membership status:', err);
      toast({
        title: "Error",
        description: err.response?.data?.message || `Failed to update membership status.`,
        variant: "destructive",
      });
    }
  };

  // Handle membership cancellation
  const handleCancelMembership = async (membershipId) => {
    try {
      const response = await userInstance.put(`/admin/memberships/${membershipId}/cancel`);
      
      toast({
        title: "Success",
        description: "Membership cancelled successfully!",
        variant: "default",
      });
      
      fetchMemberships();
      setConfirmDialog({ ...confirmDialog, isOpen: false });
    } catch (err) {
      console.error('Error cancelling membership:', err);
      toast({
        title: "Error",
        description: err.response?.data?.message || "Failed to cancel membership.",
        variant: "destructive",
      });
    }
  };

  // Handle user card update
  const handleUpdateUserCard = async (userId, cardNum) => {
    try {
      const response = await userInstance.put(`/admin/users/${userId}/card`, {
        card_number: cardNum
      });
      
      toast({
        title: "Success",
        description: "Card number updated successfully!",
        variant: "default",
      });
      
      fetchMemberships();
      setShowCardDialog(false);
    } catch (err) {
      console.error('Error updating card number:', err);
      toast({
        title: "Error",
        description: err.response?.data?.message || "Failed to update card number.",
        variant: "destructive",
      });
    }
  };

  // Handle view details
  const handleViewDetails = async (membership) => {
    setSelectedMembership(membership);
    const details = await fetchMembershipDetails(membership.membership_id);
    console.log('Membership details:', details);
    if (details) {
      setShowDetailsDialog(true);
    }
  };

  // Handle view history
  const handleViewHistory = async (membership) => {
    setSelectedMembership(membership);
    await fetchMembershipHistory(membership.membership_id);
    setShowHistoryDialog(true);
  };

  // Handle edit membership
  const handleEditMembership = (membership) => {
    setSelectedMembership(membership);
    setIsEditMode(true);
    
    form.reset({
      user_id: membership.user_id.toString(),
      plan_id: membership.plan_id.toString(),
      start_date: format(new Date(membership.start_date), 'yyyy-MM-dd'),
      end_date: format(new Date(membership.end_date), 'yyyy-MM-dd'),
      status: membership.status
    });
    
    setShowCreateDialog(true);
  };

  // Handle cancel operation
  const handleCancelOperation = () => {
    setShowCreateDialog(false);
    setShowDetailsDialog(false);
    setShowHistoryDialog(false);
    setShowCardDialog(false);
    setIsEditMode(false);
    setSelectedMembership(null);
    form.reset();
  };

  // Helper function to determine status badge color
  const getStatusBadgeVariant = (status) => {
    switch (status) {
      case MembershipStatus.Active:
        return 'success';
      case MembershipStatus.Pending:
        return 'warning';
      case MembershipStatus.Expired:
        return 'secondary';
      case MembershipStatus.Cancelled:
        return 'destructive';
      default:
        return 'secondary';
    }
  };

  // Helper function to determine status icon
  const getStatusIcon = (status) => {
    switch (status) {
      case MembershipStatus.Active:
        return <CheckCircle className="h-4 w-4 text-green-500" />;
      case MembershipStatus.Pending:
        return <HelpCircle className="h-4 w-4 text-amber-500" />;
      case MembershipStatus.Expired:
        return <AlertTriangle className="h-4 w-4 text-gray-500" />;
      case MembershipStatus.Cancelled:
        return <X className="h-4 w-4 text-red-500" />;
      default:
        return <HelpCircle className="h-4 w-4" />;
    }
  };

  // Format date helper
  const formatDate = (dateString) => {
    if (!dateString) return 'N/A';
    try {
      return format(new Date(dateString), 'MMM d, yyyy');
    } catch (e) {
      return 'Invalid Date';
    }
  };

  // Loading state
  if (loading && memberships.length === 0) {
    return (
      <DashboardLayout>
        <div className="flex items-center justify-center h-full p-8">
          <div className="text-center">
            <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary mx-auto mb-4"></div>
            <p className="text-muted-foreground">Loading memberships...</p>
            {error && <p className="text-red-500 mt-2">Error: {error}</p>}
          </div>
        </div>
      </DashboardLayout>
    );
  }

  return (
    <DashboardLayout>
      <div className="space-y-6 p-6">
        <div className="flex justify-between items-center">
          <div>
            <h1 className="text-2xl font-bold tracking-tight">Memberships</h1>
            <p className="text-muted-foreground">Manage user memberships and subscriptions</p>
          </div>
          <Button className="flex items-center gap-2" onClick={() => {
            setIsEditMode(false);
            form.reset({
              user_id: '',
              plan_id: '',
              start_date: format(new Date(), 'yyyy-MM-dd'),
              end_date: '',
              status: MembershipStatus.Pending
            });
            setShowCreateDialog(true);
          }}>
            <Plus className="h-4 w-4" />
            Create Membership
          </Button>
        </div>

        {/* Stats Cards */}
        <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
          <Card>
            <CardHeader className="flex flex-row items-center justify-between pb-2">
              <CardTitle className="text-sm font-medium">Total Memberships</CardTitle>
              <Users className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">{totalRecords}</div>
            </CardContent>
          </Card>
          
          <Card>
            <CardHeader className="flex flex-row items-center justify-between pb-2">
              <CardTitle className="text-sm font-medium">Active Memberships</CardTitle>
              <CheckCircle className="h-4 w-4 text-green-500" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">
                {memberships.filter(m => m.status === MembershipStatus.Active).length}
              </div>
            </CardContent>
          </Card>
          
          <Card>
            <CardHeader className="flex flex-row items-center justify-between pb-2">
              <CardTitle className="text-sm font-medium">Pending Approvals</CardTitle>
              <HelpCircle className="h-4 w-4 text-amber-500" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">
                {memberships.filter(m => m.status === MembershipStatus.Pending).length}
              </div>
            </CardContent>
          </Card>
          
          <Card>
            <CardHeader className="flex flex-row items-center justify-between pb-2">
              <CardTitle className="text-sm font-medium">Expired/Cancelled</CardTitle>
              <AlertTriangle className="h-4 w-4 text-red-500" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">
                {memberships.filter(m => 
                  m.status === MembershipStatus.Expired || 
                  m.status === MembershipStatus.Cancelled
                ).length}
              </div>
            </CardContent>
          </Card>
        </div>

        {/* Error Message if any */}
        {error && (
          <Card className="bg-red-50 border-red-200">
            <CardContent className="pt-6">
              <p className="text-red-500 font-medium">Error loading memberships: {error}</p>
            </CardContent>
          </Card>
        )}

        {/* Main Content Card */}
        <Card>
          <CardHeader className="pb-3">
            <CardTitle>All Memberships</CardTitle>
            <CardDescription>Manage user memberships and subscriptions</CardDescription>
          </CardHeader>
          
          <CardContent>
            {/* Search and Filters */}
            <div className="flex flex-col md:flex-row items-center justify-between gap-4 mb-6">
              <div className="relative w-full md:max-w-sm">
                <Search className="absolute left-2.5 top-2.5 h-4 w-4 text-muted-foreground" />
                <Input
                  placeholder="Search memberships..."
                  className="pl-8"
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                />
              </div>
              
              <div className="flex gap-2 w-full md:w-auto">
                <Select value={statusFilter} onValueChange={setStatusFilter}>
                  <SelectTrigger className="w-[130px]">
                    <SelectValue placeholder="Filter by Status" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="all">All Statuses</SelectItem>
                    <SelectItem value="active">Active</SelectItem>
                    <SelectItem value="pending">Pending</SelectItem>
                    <SelectItem value="expired">Expired</SelectItem>
                    <SelectItem value="cancelled">Cancelled</SelectItem>
                  </SelectContent>
                </Select>
                
                <Select value={planFilter} onValueChange={setPlanFilter}>
                  <SelectTrigger className="w-[130px]">
                    <SelectValue placeholder="Filter by Plan" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="all">All Plans</SelectItem>
                    <SelectItem value="monthly">Monthly</SelectItem>
                    <SelectItem value="quaterly">Quarterly</SelectItem>
                    <SelectItem value="yearly">Yearly</SelectItem>
                  </SelectContent>
                </Select>
                
                <Button variant="outline" size="icon" onClick={() => fetchMemberships()}>
                  <RefreshCw className="h-4 w-4" />
                </Button>
              </div>
            </div>

            {/* Table */}
            {filteredMemberships.length > 0 ? (
              <div className="rounded-md border overflow-hidden">
                <Table>
                  <TableHeader>
                    <TableRow>
                      <TableHead>Member</TableHead>
                      <TableHead>Plan</TableHead>
                      <TableHead>Start Date</TableHead>
                      <TableHead>End Date</TableHead>
                      <TableHead>Status</TableHead>
                      <TableHead>Card Number</TableHead>
                      <TableHead className="text-right">Actions</TableHead>
                    </TableRow>
                  </TableHeader>
                  <TableBody>
                    {filteredMemberships.map(membership => (
                      <TableRow key={membership.membership_id}>
                        <TableCell>
                          <div className="flex items-center gap-3">
                            <Avatar className="h-8 w-8">
                              <AvatarImage src={membership.users?.profile_image} />
                              <AvatarFallback>
                                {membership.users?.user_name?.substring(0, 2).toUpperCase() || 'UN'}
                              </AvatarFallback>
                            </Avatar>
                            <div>
                              <div className="font-medium">{membership.users?.full_name || membership.users?.user_name || 'Unknown'}</div>
                              <div className="text-xs text-muted-foreground truncate max-w-[120px]">
                                {membership.users?.email || 'No email'}
                              </div>
                            </div>
                          </div>
                        </TableCell>
                        
                        <TableCell>
                          <div>
                            <div className="font-medium">{membership.membership_plan?.plan_type || 'Unknown'}</div>
                            <div className="text-xs text-muted-foreground">
                              NPR {Number(membership.membership_plan?.price || 0).toFixed(2)} / {membership.membership_plan?.duration || 0} month(s)
                            </div>
                          </div>
                        </TableCell>
                        
                        <TableCell>
                          {formatDate(membership.start_date)}
                        </TableCell>
                        
                        <TableCell>
                          {formatDate(membership.end_date)}
                        </TableCell>
                        
                        <TableCell>
                          <div className="flex items-center gap-2">
                            {getStatusIcon(membership.status)}
                            <Badge 
                              variant={getStatusBadgeVariant(membership.status)}
                              className="capitalize"
                            >
                              {membership.status}
                            </Badge>
                          </div>
                        </TableCell>
                        
                        <TableCell>
                          <div className="flex items-center gap-2">
                            {membership.users?.card_number ? (
                              <span className="font-mono">{membership.users.card_number}</span>
                            ) : (
                              <span className="text-muted-foreground italic">Not assigned</span>
                            )}
                          </div>
                        </TableCell>
                        
                        <TableCell className="text-right">
                          {/* Approval UI for pending memberships */}
                          {membership.status === MembershipStatus.Pending && (
                            <div className="flex flex-col md:flex-row items-end gap-2 mb-2">
                              <Input 
                                type="text" 
                                placeholder="Card Number" 
                                value={cardNumber} 
                                onChange={(e) => setCardNumber(e.target.value)} 
                                className="w-full md:w-32 text-xs"
                              />
                              <Button 
                                variant="outline" 
                                size="sm"
                                className="whitespace-nowrap" onClick={() => handleApproveMembership(membership.membership_id)}
                                >
                                  <CheckCircle className="mr-1 h-3 w-3" />
                                  Approve
                                </Button>
                              </div>
                            )}
                            
                            <DropdownMenu>
                              <DropdownMenuTrigger asChild>
                                <Button variant="ghost" size="icon">
                                  <MoreHorizontal className="h-4 w-4" />
                                  <span className="sr-only">Actions</span>
                                </Button>
                              </DropdownMenuTrigger>
                              <DropdownMenuContent align="end">
                                <DropdownMenuLabel>Actions</DropdownMenuLabel>
                                <DropdownMenuItem onClick={() => handleViewDetails(membership)}>
                                  <Clipboard className="mr-2 h-4 w-4" />
                                  View Details
                                </DropdownMenuItem>
                                <DropdownMenuItem onClick={() => handleViewHistory(membership)}>
                                  <Calendar className="mr-2 h-4 w-4" />
                                  View History
                                </DropdownMenuItem>
                                <DropdownMenuItem onClick={() => {
                                  setSelectedMembership(membership);
                                  setShowCardDialog(true);
                                }}>
                                  <CreditCard className="mr-2 h-4 w-4" />
                                  Update Card
                                </DropdownMenuItem>
                                <DropdownMenuItem onClick={() => handleEditMembership(membership)}>
                                  <Edit className="mr-2 h-4 w-4" />
                                  Edit Membership
                                </DropdownMenuItem>
                                <DropdownMenuSeparator />
                                {membership.status !== MembershipStatus.Cancelled && (
                                  <DropdownMenuItem 
                                    className="text-destructive"
                                    onClick={() => setConfirmDialog({
                                      isOpen: true,
                                      title: "Cancel Membership",
                                      message: "Are you sure you want to cancel this membership? This action cannot be undone.",
                                      onConfirm: () => handleCancelMembership(membership.membership_id)
                                    })}
                                  >
                                    <Trash className="mr-2 h-4 w-4" />
                                    Cancel Membership
                                  </DropdownMenuItem>
                                )}
                              </DropdownMenuContent>
                            </DropdownMenu>
                          </TableCell>
                        </TableRow>
                      ))}
                    </TableBody>
                  </Table>
                </div>
              ) : (
                <div className="text-center py-10 border rounded-md">
                  <div className="mx-auto flex h-20 w-20 items-center justify-center rounded-full bg-muted">
                    <Users className="h-10 w-10 text-muted-foreground" />
                  </div>
                  <h3 className="mt-4 text-lg font-semibold">No memberships found</h3>
                  <p className="mt-2 text-sm text-muted-foreground">
                    {searchTerm || statusFilter !== 'all' || planFilter !== 'all' 
                      ? 'Try adjusting your filters or search term'
                      : 'Start by creating a new membership for a user'}
                  </p>
                  <Button 
                    variant="outline" 
                    className="mt-4"
                    onClick={() => {
                      setSearchTerm('');
                      setStatusFilter('all');
                      setPlanFilter('all');
                    }}
                  >
                    Reset Filters
                  </Button>
                </div>
              )}
            </CardContent>
            
            <CardFooter className="flex items-center justify-between border-t p-4">
              <div className="text-sm text-muted-foreground">
                Showing {filteredMemberships.length} of {totalRecords} memberships
              </div>
              
              <Pagination>
                <PaginationContent>
                  <PaginationItem>
                    <PaginationPrevious 
                      onClick={() => setPage(p => Math.max(1, p - 1))}
                      disabled={page === 1}
                    />
                  </PaginationItem>
                  
                  {Array.from({ length: Math.min(5, totalPages) }, (_, i) => {
                    const pageNum = page <= 3 
                      ? i + 1 
                      : page + i - 2;
                      
                    if (pageNum <= totalPages && pageNum > 0) {
                      return (
                        <PaginationItem key={pageNum}>
                          <PaginationLink 
                            isActive={pageNum === page}
                            onClick={() => setPage(pageNum)}
                          >
                            {pageNum}
                          </PaginationLink>
                        </PaginationItem>
                      );
                    }
                    return null;
                  })}
                  
                  <PaginationItem>
                    <PaginationNext 
                      onClick={() => setPage(p => Math.min(totalPages, p + 1))}
                      disabled={page === totalPages}
                    />
                  </PaginationItem>
                </PaginationContent>
              </Pagination>
            </CardFooter>
          </Card>
        </div>
  
        {/* Create/Edit Membership Dialog */}
        <Dialog open={showCreateDialog} onOpenChange={setShowCreateDialog}>
          <DialogContent className="sm:max-w-[500px]">
            <DialogHeader>
              <DialogTitle>{isEditMode ? 'Edit Membership' : 'Create New Membership'}</DialogTitle>
              <DialogDescription>
                {isEditMode 
                  ? 'Update membership details for this user.' 
                  : 'Create a new membership for a user by selecting the details below.'}
              </DialogDescription>
            </DialogHeader>
            
            <Form {...form}>
              <form onSubmit={form.handleSubmit(isEditMode ? handleUpdateMembership : handleCreateMembership)} className="space-y-4">
                <FormField
                  control={form.control}
                  name="user_id"
                  render={({ field }) => (
                    <FormItem>
                      <FormLabel>User</FormLabel>
                      <Select 
                        disabled={isEditMode} 
                        onValueChange={field.onChange} 
                        defaultValue={field.value}
                      >
                        <FormControl>
                          <SelectTrigger>
                            <SelectValue placeholder="Select a user" />
                          </SelectTrigger>
                        </FormControl>
                        <SelectContent>
                          {users.map(user => (
                            <SelectItem key={user.user_id} value={user.user_id.toString()}>
                              {user.full_name || user.user_name} ({user.email})
                            </SelectItem>
                          ))}
                        </SelectContent>
                      </Select>
                      <FormMessage />
                    </FormItem>
                  )}
                />
                
                <FormField
                  control={form.control}
                  name="plan_id"
                  render={({ field }) => (
                    <FormItem>
                      <FormLabel>Membership Plan</FormLabel>
                      <Select onValueChange={field.onChange} defaultValue={field.value}>
                        <FormControl>
                          <SelectTrigger>
                            <SelectValue placeholder="Select a plan" />
                          </SelectTrigger>
                        </FormControl>
                        <SelectContent>
                          {plans.map(plan => (
                            <SelectItem key={plan.plan_id} value={plan.plan_id.toString()}>
                              {plan.plan_type} - NPR {Number(plan.price).toFixed(2)} / {plan.duration} Month(s)
                            </SelectItem>
                          ))}
                        </SelectContent>
                      </Select>
                      <FormMessage />
                    </FormItem>
                  )}
                />


<FormField
  control={form.control}
  name="payment_method"
  render={({ field }) => (
    <FormItem>
      <FormLabel>Payment Method</FormLabel>
      <Select onValueChange={field.onChange} defaultValue={field.value}>
        <FormControl>
          <SelectTrigger>
            <SelectValue placeholder="Select payment method" />
          </SelectTrigger>
        </FormControl>
        <SelectContent>
          <SelectItem value="Cash">Cash</SelectItem>
          <SelectItem value="Khalti">Khalti</SelectItem>
          <SelectItem value="Online">Online</SelectItem>
        </SelectContent>
      </Select>
      <FormDescription>
        Select how the payment was or will be made
      </FormDescription>
      <FormMessage />
    </FormItem>
  )}
/>
                
                <div className="grid grid-cols-2 gap-4">
                  <FormField
                    control={form.control}
                    name="start_date"
                    render={({ field }) => (
                      <FormItem>
                        <FormLabel>Start Date</FormLabel>
                        <FormControl>
                          <Input type="date" {...field} />
                        </FormControl>
                        <FormMessage />
                      </FormItem>
                    )}
                  />
                  
                  <FormField
                    control={form.control}
                    name="end_date"
                    render={({ field }) => (
                      <FormItem>
                        <FormLabel>End Date</FormLabel>
                        <FormControl>
                          <Input type="date" {...field} />
                        </FormControl>
                        <FormMessage />
                      </FormItem>
                    )}
                  />
                </div>
                
                {!isEditMode && (
                  <FormField
                    control={form.control}
                    name="status"
                    render={({ field }) => (
                      <FormItem>
                        <FormLabel>Status</FormLabel>
                        <Select onValueChange={field.onChange} defaultValue={field.value}>
                          <FormControl>
                            <SelectTrigger>
                              <SelectValue placeholder="Select status" />
                            </SelectTrigger>
                          </FormControl>
                          <SelectContent>
                            <SelectItem value={MembershipStatus.Pending}>Pending</SelectItem>
                            <SelectItem value={MembershipStatus.Active}>Active</SelectItem>
                          </SelectContent>
                        </Select>
                        <FormMessage />
                      </FormItem>
                    )}
                  />
                )}
                
                <DialogFooter>
                  <Button type="button" variant="outline" onClick={handleCancelOperation}>
                    Cancel
                  </Button>
                  <Button type="submit">{isEditMode ? 'Update' : 'Create'}</Button>
                </DialogFooter>
              </form>
            </Form>
          </DialogContent>
        </Dialog>
  
        {/* Membership Details Dialog */}
        <Dialog open={showDetailsDialog} onOpenChange={setShowDetailsDialog}>
          <DialogContent className="sm:max-w-[600px]">
            <DialogHeader>
              <DialogTitle>Membership Details</DialogTitle>
              <DialogDescription>
                Detailed information about this membership.
              </DialogDescription>
            </DialogHeader>
            
            {membershipDetails && (
              <Tabs defaultValue="details" className="w-full">
                <TabsList className="grid w-full grid-cols-3">
                  <TabsTrigger value="details">Details</TabsTrigger>
                  <TabsTrigger value="payments">Payments</TabsTrigger>
                  <TabsTrigger value="user">User Info</TabsTrigger>
                </TabsList>
                
                <TabsContent value="details" className="space-y-4 pt-4">
                  <div className="grid grid-cols-2 gap-4">
                    <div>
                      <h4 className="text-sm font-medium text-muted-foreground">Membership ID</h4>
                      <p>{membershipDetails.membership_id}</p>
                    </div>
                    <div>
                      <h4 className="text-sm font-medium text-muted-foreground">Status</h4>
                      <div className="flex items-center gap-2 mt-1">
                        {getStatusIcon(membershipDetails.status)}
                        <Badge variant={getStatusBadgeVariant(membershipDetails.status)}>
                          {membershipDetails.status}
                        </Badge>
                      </div>
                    </div>
                    <div>
                      <h4 className="text-sm font-medium text-muted-foreground">Plan Type</h4>
                      <p>{membershipDetails.membership_plan?.plan_type}</p>
                    </div>
                    <div>
                      <h4 className="text-sm font-medium text-muted-foreground">Price</h4>
                      <p>NPR {Number(membershipDetails.membership_plan?.price || 0).toFixed(2)}</p>
                    </div>
                    <div>
                      <h4 className="text-sm font-medium text-muted-foreground">Start Date</h4>
                      <p>{formatDate(membershipDetails.start_date)}</p>
                    </div>
                    <div>
                      <h4 className="text-sm font-medium text-muted-foreground">End Date</h4>
                      <p>{formatDate(membershipDetails.end_date)}</p>
                    </div>
                    <div>
                      <h4 className="text-sm font-medium text-muted-foreground">Created At</h4>
                      <p>{formatDate(membershipDetails.created_at)}</p>
                    </div>
                    <div>
                      <h4 className="text-sm font-medium text-muted-foreground">Last Updated</h4>
                      <p>{formatDate(membershipDetails.updated_at)}</p>
                    </div>
                  </div>
                </TabsContent>
                
                <TabsContent value="payments" className="pt-4">
                  {membershipDetails.payments && membershipDetails.payments.length > 0 ? (
                    <div className="rounded-md border overflow-hidden">
                      <Table>
                        <TableHeader>
                          <TableRow>
                            <TableHead>Payment ID</TableHead>
                            <TableHead>Date</TableHead>
                            <TableHead>Amount</TableHead>
                            <TableHead>Method</TableHead>
                            <TableHead>Status</TableHead>
                          </TableRow>
                        </TableHeader>
                        <TableBody>
                          {membershipDetails.payments.map(payment => (
                            <TableRow key={payment.payment_id}>
                              <TableCell>{payment.payment_id}</TableCell>
                              <TableCell>{formatDate(payment.payment_date)}</TableCell>
                              <TableCell>NPR {Number(payment.price).toFixed(2)}</TableCell>
                              <TableCell className="capitalize">{payment.payment_method}</TableCell>
                              <TableCell>
                                <Badge 
                                  variant={payment.payment_status === 'Paid' ? 'success' : 'warning'}
                                >
                                  {payment.payment_status}
                                </Badge>
                              </TableCell>
                            </TableRow>
                          ))}
                        </TableBody>
                      </Table>
                    </div>
                  ) : (
                    <div className="text-center py-8 border rounded-md">
                      <p className="text-muted-foreground">No payment records found</p>
                    </div>
                  )}
                </TabsContent>
                
                <TabsContent value="user" className="pt-4">
                  {membershipDetails.users && (
                    <div className="space-y-4">
                      <div className="flex items-center gap-4">
                        <Avatar className="h-16 w-16">
                          <AvatarImage src={membershipDetails.users.profile_image} />
                          <AvatarFallback>
                            {membershipDetails.users.user_name?.substring(0, 2).toUpperCase() || 'UN'}
                          </AvatarFallback>
                        </Avatar>
                        <div>
                          <h3 className="text-lg font-medium">{membershipDetails.users.full_name || membershipDetails.users.user_name}</h3>
                          <p className="text-sm text-muted-foreground">{membershipDetails.users.email}</p>
                        </div>
                      </div>
                      
                      <div className="grid grid-cols-2 gap-4">
                        <div>
                          <h4 className="text-sm font-medium text-muted-foreground">Phone Number</h4>
                          <p>{membershipDetails.users.phone_number || 'Not provided'}</p>
                        </div>
                        <div>
                          <h4 className="text-sm font-medium text-muted-foreground">Card Number</h4>
                          <p>{membershipDetails.users.card_number || 'Not assigned'}</p>
                        </div>
                        <div>
                          <h4 className="text-sm font-medium text-muted-foreground">Address</h4>
                          <p>{membershipDetails.users.address || 'Not provided'}</p>
                        </div>
                        <div>
                          <h4 className="text-sm font-medium text-muted-foreground">Role</h4>
                          <p className="capitalize">{membershipDetails.users.role}</p>
                        </div>
                      </div>
                    </div>
                  )}
                </TabsContent>
              </Tabs>
            )}
            
            <DialogFooter>
              <Button variant="outline" onClick={handleCancelOperation}>
                Close
              </Button>
            </DialogFooter>
          </DialogContent>
        </Dialog>
  
        {/* Membership History Dialog */}
        <Dialog open={showHistoryDialog} onOpenChange={setShowHistoryDialog}>
          <DialogContent className="sm:max-w-[600px]">
            <DialogHeader>
              <DialogTitle>Membership History</DialogTitle>
              <DialogDescription>
                History of changes made to this membership
              </DialogDescription>
            </DialogHeader>
            
            {membershipHistory.length > 0 ? (
              <div className="rounded-md border overflow-hidden">
                <Table>
                  <TableHeader>
                    <TableRow>
                      <TableHead>Date</TableHead>
                      <TableHead>Previous Plan</TableHead>
                      <TableHead>New Plan</TableHead>
                      <TableHead>Action</TableHead>
                    </TableRow>
                  </TableHeader>
                  <TableBody>
                    {membershipHistory.map(change => (
                      <TableRow key={change.change_id}>
                        <TableCell>{formatDate(change.change_date)}</TableCell>
                        <TableCell>{change.previous_plan}</TableCell>
                        <TableCell>{change.new_plan}</TableCell>
                        <TableCell>{change.action}</TableCell>
                      </TableRow>
                    ))}
                  </TableBody>
                </Table>
              </div>
            ) : (
              <div className="text-center py-8 border rounded-md">
                <p className="text-muted-foreground">No history records found</p>
              </div>
            )}
            
            <DialogFooter>
              <Button variant="outline" onClick={handleCancelOperation}>
                Close
              </Button>
            </DialogFooter>
          </DialogContent>
        </Dialog>
  
        {/* Update Card Dialog */}
        <Dialog open={showCardDialog} onOpenChange={setShowCardDialog}>
          <DialogContent className="sm:max-w-[400px]">
            <DialogHeader>
              <DialogTitle>Update Card Number</DialogTitle>
              <DialogDescription>
                Assign a new card number to this user
              </DialogDescription>
            </DialogHeader>
            
            {selectedMembership && (
              <div className="space-y-4">
                <div className="flex items-center gap-3">
                  <Avatar className="h-10 w-10">
                    <AvatarImage src={selectedMembership.users?.profile_image} />
                    <AvatarFallback>
                      {selectedMembership.users?.user_name?.substring(0, 2).toUpperCase() || 'UN'}
                    </AvatarFallback>
                  </Avatar>
                  <div>
                    <div className="font-medium">
                      {selectedMembership.users?.full_name || selectedMembership.users?.user_name}
                    </div>
                    <div className="text-xs text-muted-foreground">
                      {selectedMembership.users?.email}
                    </div>
                  </div>
                </div>
                
                <div className="space-y-2">
                  <Label htmlFor="cardNumber">New Card Number</Label>
                  <Input
                    id="cardNumber"
                    placeholder="Enter card number"
                    value={cardNumber}
                    onChange={(e) => setCardNumber(e.target.value)}
                  />
                </div>
              </div>
            )}
            
            <DialogFooter>
              <Button variant="outline" onClick={handleCancelOperation}>
                Cancel
              </Button>
              <Button 
                onClick={() => handleUpdateUserCard(selectedMembership.user_id, cardNumber)}
                disabled={!cardNumber.trim()}
              >
                Update Card
              </Button>
            </DialogFooter>
          </DialogContent>
        </Dialog>
  
        {/* Confirmation Dialog */}
        <AlertDialog open={confirmDialog.isOpen} onOpenChange={(isOpen) => 
          setConfirmDialog({...confirmDialog, isOpen})
        }>
          <AlertDialogContent>
            <AlertDialogHeader>
              <AlertDialogTitle>{confirmDialog.title}</AlertDialogTitle>
              <AlertDialogDescription>
                {confirmDialog.message}
              </AlertDialogDescription>
            </AlertDialogHeader>
            <AlertDialogFooter>
              <AlertDialogCancel onClick={() => setConfirmDialog({...confirmDialog, isOpen: false})}>
                Cancel
              </AlertDialogCancel>
              <AlertDialogAction onClick={confirmDialog.onConfirm}>
                Confirm
              </AlertDialogAction>
            </AlertDialogFooter>
          </AlertDialogContent>
        </AlertDialog>
      </DashboardLayout>
    );
  };
  
  // Forgot to import this in the first part
  import { Label } from "@/components/ui/label";
  
  export default MembershipsPage;
                                

                                