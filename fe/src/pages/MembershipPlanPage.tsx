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
  DialogHeader, DialogTitle
} from "@/components/ui/dialog";
import {
  Form, FormControl, FormDescription, FormField,
  FormItem, FormLabel, FormMessage
} from "@/components/ui/form";
import {
  Select, SelectContent, SelectItem, SelectTrigger, SelectValue
} from "@/components/ui/select";
import { Textarea } from "@/components/ui/textarea";
import { 
  Search, Plus, MoreHorizontal, Edit, Trash, RefreshCw, 
  DollarSign, Calendar, CreditCard
} from 'lucide-react';
import { Badge } from '@/components/ui/badge';
import { format } from 'date-fns';
import { useToast } from '@/components/ui/use-toast';
import { userInstance } from '@/network/axios';
import {
  AlertDialog, AlertDialogAction, AlertDialogCancel, AlertDialogContent,
  AlertDialogDescription, AlertDialogFooter, AlertDialogHeader,
  AlertDialogTitle
} from "@/components/ui/alert-dialog";
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import * as z from 'zod';

export const PlanType = {
  Monthly: 'Monthly',
  Quaterly: 'Quaterly',
  Yearly: 'Yearly'
};

// Form validation schema
const planFormSchema = z.object({
  plan_type: z.string().min(1, "Plan type is required"),
  price: z.string().min(1, "Price is required")
    .refine(val => !isNaN(parseFloat(val)) && parseFloat(val) > 0, {
      message: "Price must be a positive number"
    }),
  duration: z.string().min(1, "Duration is required")
    .refine(val => !isNaN(parseInt(val)) && parseInt(val) > 0, {
      message: "Duration must be a positive integer"
    }),
  description: z.string().min(1, "Description is required")
});

const MembershipPlansPage = () => {
  const { toast } = useToast();
  
  // State for plans
  const [plans, setPlans] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [searchTerm, setSearchTerm] = useState('');
  const [filteredPlans, setFilteredPlans] = useState([]);
  
  // State for dialogs
  const [showCreateDialog, setShowCreateDialog] = useState(false);
  const [isEditMode, setIsEditMode] = useState(false);
  const [selectedPlan, setSelectedPlan] = useState(null);
  
  // State for delete confirmation
  const [confirmDialog, setConfirmDialog] = useState({
    isOpen: false,
    title: '',
    message: '',
    onConfirm: null
  });

  // Form setup
  const form = useForm({
    resolver: zodResolver(planFormSchema),
    defaultValues: {
      plan_type: '',
      price: '',
      duration: '',
      description: ''
    }
  });

  // Fetch plans on component mount
  useEffect(() => {
    fetchPlans();
  }, []);

  // Apply search filter
  useEffect(() => {
    if (!plans.length) return;
    
    let filtered = [...plans];
    
    // Apply search term
    if (searchTerm) {
      filtered = filtered.filter(plan => 
        plan.plan_type.toLowerCase().includes(searchTerm.toLowerCase()) ||
        plan.description.toLowerCase().includes(searchTerm.toLowerCase())
      );
    }
    
    setFilteredPlans(filtered);
  }, [plans, searchTerm]);

  // Fetch all membership plans
  const fetchPlans = async () => {
    setLoading(true);
    try {
      const response = await userInstance.get('/admin/membership-plans');
      console.log('Plans API response:', response.data);
      
      setPlans(response.data.data);
      setFilteredPlans(response.data.data);
    } catch (err) {
      console.error('Error fetching plans:', err);
      setError(err.message || 'Failed to load membership plans');
      toast({
        title: "Error",
        description: "Failed to load membership plans. Please try again.",
        variant: "destructive",
      });
    } finally {
      setLoading(false);
    }
  };

  // Handle plan creation
  const handleCreatePlan = async (data) => {
    try {
      const payload = {
        plan_type: data.plan_type,
        price: parseFloat(data.price),
        duration: parseInt(data.duration),
        description: data.description
      };

      const response = await userInstance.post('/admin/membership-plans', payload);
      
      toast({
        title: "Success",
        description: "Membership plan created successfully!",
        variant: "default",
      });
      
      fetchPlans();
      setShowCreateDialog(false);
      form.reset();
    } catch (err) {
      console.error('Error creating plan:', err);
      toast({
        title: "Error",
        description: err.response?.data?.message || "Failed to create membership plan.",
        variant: "destructive",
      });
    }
  };

  // Handle plan update
  const handleUpdatePlan = async (data) => {
    try {
      const payload = {
        plan_type: data.plan_type,
        price: parseFloat(data.price),
        duration: parseInt(data.duration),
        description: data.description
      };

      const response = await userInstance.put(`/admin/membership-plans/${selectedPlan.plan_id}`, payload);
      
      toast({
        title: "Success",
        description: "Membership plan updated successfully!",
        variant: "default",
      });
      
      fetchPlans();
      setShowCreateDialog(false);
      setIsEditMode(false);
      form.reset();
    } catch (err) {
      console.error('Error updating plan:', err);
      toast({
        title: "Error",
        description: err.response?.data?.message || "Failed to update membership plan.",
        variant: "destructive",
      });
    }
  };

  // Handle plan deletion
  const handleDeletePlan = async (planId) => {
    try {
      const response = await userInstance.delete(`/admin/membership-plans/${planId}`);
      
      toast({
        title: "Success",
        description: "Membership plan deleted successfully!",
        variant: "default",
      });
      
      fetchPlans();
      setConfirmDialog({ ...confirmDialog, isOpen: false });
    } catch (err) {
      console.error('Error deleting plan:', err);
      
      // Special handling for plans in use
      if (err.response?.status === 400) {
        toast({
          title: "Cannot Delete",
          description: "This plan is currently in use by active memberships.",
          variant: "destructive",
        });
      } else {
        toast({
          title: "Error",
          description: err.response?.data?.message || "Failed to delete membership plan.",
          variant: "destructive",
        });
      }
      
      setConfirmDialog({ ...confirmDialog, isOpen: false });
    }
  };

  // Handle edit plan
  const handleEditPlan = (plan) => {
    setSelectedPlan(plan);
    setIsEditMode(true);
    
    form.reset({
      plan_type: plan.plan_type,
      price: plan.price.toString(),
      duration: plan.duration.toString(),
      description: plan.description
    });
    
    setShowCreateDialog(true);
  };

  // Handle cancel operation
  const handleCancelOperation = () => {
    setShowCreateDialog(false);
    setIsEditMode(false);
    setSelectedPlan(null);
    form.reset();
  };

  // Helper function to get duration text
  const getDurationText = (months) => {
    if (months === 1) return "1 month";
    if (months === 3) return "3 months";
    if (months === 12) return "1 year";
    return `${months} months`;
  };

  // Loading state
  if (loading && plans.length === 0) {
    return (
      <DashboardLayout>
        <div className="flex items-center justify-center h-full p-8">
          <div className="text-center">
            <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary mx-auto mb-4"></div>
            <p className="text-muted-foreground">Loading membership plans...</p>
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
            <h1 className="text-2xl font-bold tracking-tight">Membership Plans</h1>
            <p className="text-muted-foreground">Manage available membership plans in your system</p>
          </div>
          <Button className="flex items-center gap-2" onClick={() => {
            setIsEditMode(false);
            form.reset({
              plan_type: '',
              price: '',
              duration: '',
              description: ''
            });
            setShowCreateDialog(true);
          }}>
            <Plus className="h-4 w-4" />
            Create New Plan
          </Button>
        </div>

        {/* Stats Cards */}
        <div className="grid gap-4 md:grid-cols-3">
          <Card>
            <CardHeader className="flex flex-row items-center justify-between pb-2">
              <CardTitle className="text-sm font-medium">Total Plans</CardTitle>
              <CreditCard className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">{plans.length}</div>
            </CardContent>
          </Card>
          
          <Card>
            <CardHeader className="flex flex-row items-center justify-between pb-2">
              <CardTitle className="text-sm font-medium">Lowest Plan</CardTitle>
              <DollarSign className="h-4 w-4 text-green-500" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">
                ${Math.min(...plans.map(p => p.price).filter(p => !isNaN(p)), 0).toFixed(2)}
              </div>
            </CardContent>
          </Card>
          
          <Card>
            <CardHeader className="flex flex-row items-center justify-between pb-2">
              <CardTitle className="text-sm font-medium">Highest Plan</CardTitle>
              {/* <DollarSign className="h-4 w-4 text-amber-500" /> */}
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">
                ${Math.max(...plans.map(p => p.price).filter(p => !isNaN(p)), 0).toFixed(2)}
              </div>
            </CardContent>
          </Card>
        </div>

        {/* Error Message if any */}
        {error && (
          <Card className="bg-red-50 border-red-200">
            <CardContent className="pt-6">
              <p className="text-red-500 font-medium">Error loading plans: {error}</p>
            </CardContent>
          </Card>
        )}

        {/* Main Content Card */}
        <Card>
          <CardHeader className="pb-3">
            <CardTitle>All Membership Plans</CardTitle>
            <CardDescription>Configure and manage available membership plans</CardDescription>
          </CardHeader>
          
          <CardContent>
            {/* Search */}
            <div className="flex flex-col md:flex-row items-center justify-between gap-4 mb-6">
              <div className="relative w-full md:max-w-sm">
                <Search className="absolute left-2.5 top-2.5 h-4 w-4 text-muted-foreground" />
                <Input
                  placeholder="Search plans..."
                  className="pl-8"
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                />
              </div>
              
              <Button variant="outline" size="icon" onClick={() => fetchPlans()}>
                <RefreshCw className="h-4 w-4" />
              </Button>
            </div>

            {/* Table */}
            {filteredPlans.length > 0 ? (
              <div className="rounded-md border overflow-hidden">
                <Table>
                  <TableHeader>
                    <TableRow>
                      <TableHead>Plan Type</TableHead>
                      <TableHead>Price</TableHead>
                      <TableHead>Duration</TableHead>
                      <TableHead>Description</TableHead>
                      <TableHead className="text-right">Actions</TableHead>
                    </TableRow>
                  </TableHeader>
                  <TableBody>
                    {filteredPlans.map(plan => (
                      <TableRow key={plan.plan_id}>
                        <TableCell>
                          <div className="font-medium">{plan.plan_type}</div>
                        </TableCell>
                        
                        <TableCell>
                          <div className="font-mono">${Number(plan.price).toFixed(2)}</div>
                        </TableCell>
                        
                        <TableCell>
                          <div className="flex items-center gap-2">
                            <Calendar className="h-4 w-4 text-muted-foreground" />
                            <span>{getDurationText(plan.duration)}</span>
                          </div>
                        </TableCell>
                        
                        <TableCell>
                          <div className="max-w-md truncate">{plan.description}</div>
                        </TableCell>
                        
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
                              <DropdownMenuItem onClick={() => handleEditPlan(plan)}>
                                <Edit className="mr-2 h-4 w-4" />
                                Edit Plan
                              </DropdownMenuItem>
                              <DropdownMenuSeparator />
                              <DropdownMenuItem 
                                className="text-destructive"
                                onClick={() => setConfirmDialog({
                                  isOpen: true,
                                  title: "Delete Membership Plan",
                                  message: "Are you sure you want to delete this plan? This action cannot be undone. Plans that are in use cannot be deleted.",
                                  onConfirm: () => handleDeletePlan(plan.plan_id)
                                })}
                              >
                                <Trash className="mr-2 h-4 w-4" />
                                Delete Plan
                              </DropdownMenuItem>
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
                  <CreditCard className="h-10 w-10 text-muted-foreground" />
                </div>
                <h3 className="mt-4 text-lg font-semibold">No plans found</h3>
                <p className="mt-2 text-sm text-muted-foreground">
                  {searchTerm 
                    ? 'Try adjusting your search term'
                    : 'Start by creating a new membership plan'}
                </p>
                {searchTerm && (
                  <Button 
                    variant="outline" 
                    className="mt-4"
                    onClick={() => setSearchTerm('')}
                  >
                    Clear Search
                  </Button>
                )}
              </div>
            )}
          </CardContent>
        </Card>
      </div>

      {/* Create/Edit Plan Dialog */}
      <Dialog open={showCreateDialog} onOpenChange={setShowCreateDialog}>
        <DialogContent className="sm:max-w-[500px]">
          <DialogHeader>
            <DialogTitle>{isEditMode ? 'Edit Membership Plan' : 'Create New Membership Plan'}</DialogTitle>
            <DialogDescription>
              {isEditMode 
                ? 'Update the details of this membership plan.' 
                : 'Create a new membership plan by filling in the details below.'}
            </DialogDescription>
          </DialogHeader>
          
          <Form {...form}>
            <form onSubmit={form.handleSubmit(isEditMode ? handleUpdatePlan : handleCreatePlan)} className="space-y-4">
              <FormField
                control={form.control}
                name="plan_type"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Plan Type</FormLabel>
                    <Select onValueChange={field.onChange} value={field.value}>
                      <FormControl>
                        <SelectTrigger>
                          <SelectValue placeholder="Select plan type" />
                        </SelectTrigger>
                      </FormControl>
                      <SelectContent>
                        <SelectItem value={PlanType.Monthly}>Monthly</SelectItem>
                        <SelectItem value={PlanType.Quaterly}>Quarterly</SelectItem>
                        <SelectItem value={PlanType.Yearly}>Yearly</SelectItem>
                      </SelectContent>
                    </Select>
                    <FormMessage />
                  </FormItem>
                )}
              />
              
              <div className="grid grid-cols-2 gap-4">
                <FormField
                  control={form.control}
                  name="price"
                  render={({ field }) => (
                    <FormItem>
                      <FormLabel>Price (NPR)</FormLabel>
                      <FormControl>
                        <Input type="number" step="0.01" min="0" placeholder="0.00" {...field} />
                      </FormControl>
                      <FormMessage />
                    </FormItem>
                  )}
                />
                
                <FormField
                  control={form.control}
                  name="duration"
                  render={({ field }) => (
                    <FormItem>
                      <FormLabel>Duration (months)</FormLabel>
                      <FormControl>
                        <Input type="number" min="1" placeholder="1" {...field} />
                      </FormControl>
                      <FormMessage />
                    </FormItem>
                  )}
                />
              </div>
              
              <FormField
                control={form.control}
                name="description"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Description</FormLabel>
                    <FormControl>
                      <Textarea 
                        placeholder="Enter a description for this plan" 
                        className="resize-none"
                        {...field} 
                      />
                    </FormControl>
                    <FormMessage />
                  </FormItem>
                )}
              />
              
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
              Delete
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </DashboardLayout>
  );
};

export default MembershipPlansPage;