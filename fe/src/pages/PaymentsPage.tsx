
import React, { useState } from 'react';
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
} from '@/components/ui/dropdown-menu';
import { Search, Plus, MoreHorizontal, Receipt, FileText, Filter } from 'lucide-react';
import { Badge } from '@/components/ui/badge';
import { format } from 'date-fns';
import { payments, users } from '@/lib/data';
import { PaymentStatus } from '@/types';

const PaymentsPage = () => {
  const [searchTerm, setSearchTerm] = useState('');
  
  // Combine data to show user names
  const paymentData = payments.map(payment => {
    const user = users.find(u => u.user_id === payment.user_id);
    
    return {
      ...payment,
      user_name: user?.full_name || 'Unknown',
    };
  });
  
  const filteredPayments = paymentData.filter(payment => 
    payment.user_name.toLowerCase().includes(searchTerm.toLowerCase()) ||
    payment.transaction_id.toLowerCase().includes(searchTerm.toLowerCase()) ||
    payment.payment_method.toLowerCase().includes(searchTerm.toLowerCase()) ||
    payment.payment_status.toLowerCase().includes(searchTerm.toLowerCase())
  );

  const getStatusBadgeVariant = (status: PaymentStatus) => {
    switch (status) {
      case PaymentStatus.Paid:
        return 'default';
      case PaymentStatus.Pending:
        return 'outline';
      case PaymentStatus.Failed:
        return 'destructive';
      default:
        return 'secondary';
    }
  };

  return (
    <DashboardLayout>
      <div className="space-y-6">
        <div className="flex justify-between items-center">
          <h1 className="text-2xl font-bold tracking-tight">Payments</h1>
          <Button className="flex items-center gap-2">
            <Plus className="h-4 w-4" />
            Record Payment
          </Button>
        </div>

        <Card>
          <CardHeader className="pb-3">
            <CardTitle>Payment History</CardTitle>
            <CardDescription>View and manage all payment transactions</CardDescription>
          </CardHeader>
          <CardContent>
            <div className="flex items-center justify-between mb-4">
              <div className="relative w-full max-w-sm">
                <Search className="absolute left-2.5 top-2.5 h-4 w-4 text-muted-foreground" />
                <Input
                  placeholder="Search payments..."
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

            <div className="rounded-md border">
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead>Transaction ID</TableHead>
                    <TableHead>Member</TableHead>
                    <TableHead>Amount</TableHead>
                    <TableHead>Method</TableHead>
                    <TableHead>Date</TableHead>
                    <TableHead>Status</TableHead>
                    <TableHead className="text-right">Actions</TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {filteredPayments.map(payment => (
                    <TableRow key={payment.payment_id}>
                      <TableCell className="font-medium">
                        {payment.transaction_id}
                      </TableCell>
                      <TableCell>
                        {payment.user_name}
                      </TableCell>
                      <TableCell>
                        ${payment.price}
                      </TableCell>
                      <TableCell>
                        {payment.payment_method}
                      </TableCell>
                      <TableCell>
                        {format(new Date(payment.payment_date), 'MMM d, yyyy')}
                      </TableCell>
                      <TableCell>
                        <Badge variant={getStatusBadgeVariant(payment.payment_status)}>
                          {payment.payment_status}
                        </Badge>
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
                            <DropdownMenuItem>
                              <Receipt className="mr-2 h-4 w-4" />
                              View Details
                            </DropdownMenuItem>
                            <DropdownMenuItem>
                              <FileText className="mr-2 h-4 w-4" />
                              Download Receipt
                            </DropdownMenuItem>
                            <DropdownMenuSeparator />
                            <DropdownMenuItem>
                              Update Status
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
    </DashboardLayout>
  );
};

export default PaymentsPage;
