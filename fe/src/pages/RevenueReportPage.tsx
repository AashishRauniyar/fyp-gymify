import React, { useState, useEffect } from 'react';
import DashboardLayout from '@/components/layout/DashboardLayout';
import { Card, CardContent, CardDescription, CardHeader, CardTitle, CardFooter } from '@/components/ui/card';
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table';
import { Button } from '@/components/ui/button';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { Input } from '@/components/ui/input';
import { Calendar } from '@/components/ui/calendar';
import { Popover, PopoverContent, PopoverTrigger } from '@/components/ui/popover';
import { LineChart, BarChart, Line, Bar, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer } from 'recharts';
import { DateRange } from 'react-day-picker';
import { format, parse, subMonths, startOfMonth, endOfMonth } from 'date-fns';
import { useToast } from '@/components/ui/use-toast';
import { userInstance } from '@/network/axios';
import { CalendarIcon, Download, RefreshCw, Search, ArrowUpDown, DollarSign, CreditCard, Calendar as CalendarIcon2, UsersIcon } from 'lucide-react';

const RevenueReportPage = () => {
  const { toast } = useToast();
  
  // State for report data
  const [monthlyRevenue, setMonthlyRevenue] = useState(null);
  const [payments, setPayments] = useState([]);
  const [filteredPayments, setFilteredPayments] = useState([]);
  
  // State for filters
  const [selectedYear, setSelectedYear] = useState(new Date().getFullYear());
  const [searchTerm, setSearchTerm] = useState('');
  const [statusFilter, setStatusFilter] = useState('all');
  const [dateRange, setDateRange] = useState({
    from: subMonths(new Date(), 1),
    to: new Date()
  });
  const [dateRangeOpen, setDateRangeOpen] = useState(false);
  
  // State for pagination
  const [page, setPage] = useState(1);
  const [pageSize, setPageSize] = useState(10);
  const [totalPages, setTotalPages] = useState(1);
  const [totalRecords, setTotalRecords] = useState(0);
  
  // State for loading and error
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  
  // State for summary data
  const [summaryData, setSummaryData] = useState({
    totalRevenue: 0,
    paidPayments: 0,
    pendingPayments: 0,
    activeMembers: 0
  });
  
  // Get available years for the dropdown
  const currentYear = new Date().getFullYear();
  const yearOptions = Array.from({ length: 5 }, (_, i) => currentYear - i);

  // Fetch data on component mount
  useEffect(() => {
    fetchMonthlyRevenue(selectedYear);
    fetchPayments();
  }, [selectedYear]);

  // Apply filters to payments data
  useEffect(() => {
    if (!payments.length) return;
    
    let filtered = [...payments];
    
    // Apply status filter
    if (statusFilter !== 'all') {
      filtered = filtered.filter(payment => 
        payment.payment_status?.toLowerCase() === statusFilter.toLowerCase()
      );
    }
    
    // Apply date range filter
    if (dateRange.from && dateRange.to) {
      filtered = filtered.filter(payment => {
        const paymentDate = new Date(payment.payment_date);
        return paymentDate >= dateRange.from && paymentDate <= dateRange.to;
      });
    }
    
    // Apply search term
    if (searchTerm) {
      filtered = filtered.filter(payment => 
        (payment.users?.full_name?.toLowerCase().includes(searchTerm.toLowerCase())) ||
        (payment.users?.email?.toLowerCase().includes(searchTerm.toLowerCase())) ||
        (payment.transaction_id?.toLowerCase().includes(searchTerm.toLowerCase())) ||
        (payment.payment_method?.toLowerCase().includes(searchTerm.toLowerCase()))
      );
    }
    
    setFilteredPayments(filtered);
    
    // Paginate data
    const startIndex = (page - 1) * pageSize;
    const endIndex = startIndex + pageSize;
    
    setTotalPages(Math.ceil(filtered.length / pageSize));
    setTotalRecords(filtered.length);
    
    // Calculate summary data
    const totalRevenue = filtered.reduce((sum, payment) => 
      payment.payment_status === 'Paid' ? sum + Number(payment.price) : sum, 0
    );
    
    const paidPayments = filtered.filter(payment => payment.payment_status === 'Paid').length;
    const pendingPayments = filtered.filter(payment => payment.payment_status === 'Pending').length;
    
    setSummaryData({
      totalRevenue,
      paidPayments,
      pendingPayments,
      activeMembers: filtered.length
    });
    
  }, [payments, searchTerm, statusFilter, dateRange, page, pageSize]);

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

  // Fetch payments data
  const fetchPayments = async () => {
    setLoading(true);
    try {
      // Convert date range to API format
      const startDate = dateRange.from ? format(dateRange.from, 'yyyy-MM-dd') : undefined;
      const endDate = dateRange.to ? format(dateRange.to, 'yyyy-MM-dd') : undefined;
      
      const response = await userInstance.get('/admin/payments', {
        params: {
          status: statusFilter !== 'all' ? statusFilter : undefined,
          startDate,
          endDate,
          page: 1,
          limit: 1000 // Get a large batch for client-side filtering
        }
      });
      
      console.log('Payments API response:', response.data);
      
      const paymentsData = response.data.data.payments || [];
      setPayments(paymentsData);
      setFilteredPayments(paymentsData);
      
      // Reset page to 1 when new data is fetched
      setPage(1);
    } catch (err) {
      console.error('Error fetching payments:', err);
      setError(err.message || 'Failed to load payments data');
      toast({
        title: "Error",
        description: "Failed to load payments data. Please try again.",
        variant: "destructive",
      });
    } finally {
      setLoading(false);
    }
  };

  // Format currency
  const formatCurrency = (amount) => {
    return new Intl.NumberFormat('en-US', {
      style: 'currency',
      currency: 'USD',
      minimumFractionDigits: 2
    }).format(amount);
  };

  // Handle date range select
  const handleDateRangeSelect = (range) => {
    setDateRange(range);
    if (range.from && range.to) {
      setDateRangeOpen(false);
    }
  };

  // Handle export to CSV
  const handleExportCSV = () => {
    if (!filteredPayments.length) return;
    
    // Create CSV header
    const headers = [
      'Payment ID',
      'User',
      'Email',
      'Plan',
      'Amount',
      'Method',
      'Date',
      'Status',
      'Transaction ID'
    ].join(',');
    
    // Create CSV rows
    const rows = filteredPayments.map(payment => [
      payment.payment_id,
      payment.users?.full_name || 'Unknown',
      payment.users?.email || 'N/A',
      payment.memberships?.membership_plan?.plan_type || 'N/A',
      payment.price,
      payment.payment_method,
      payment.payment_date ? format(new Date(payment.payment_date), 'yyyy-MM-dd') : 'N/A',
      payment.payment_status,
      payment.transaction_id || 'N/A'
    ].join(','));
    
    // Combine header and rows
    const csvContent = [headers, ...rows].join('\n');
    
    // Create a blob and download link
    const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
    const url = URL.createObjectURL(blob);
    const link = document.createElement('a');
    link.setAttribute('href', url);
    link.setAttribute('download', `revenue_report_${format(new Date(), 'yyyy-MM-dd')}.csv`);
    link.style.display = 'none';
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
  };

  // Format date
  const formatDate = (dateString) => {
    if (!dateString) return 'N/A';
    try {
      return format(new Date(dateString), 'MMM d, yyyy');
    } catch (e) {
      return 'Invalid Date';
    }
  };

  // Get payment status badge color
  const getStatusBadgeColor = (status) => {
    switch (status?.toLowerCase()) {
      case 'paid':
        return 'bg-green-100 text-green-800';
      case 'pending':
        return 'bg-yellow-100 text-yellow-800';
      case 'failed':
        return 'bg-red-100 text-red-800';
      default:
        return 'bg-gray-100 text-gray-800';
    }
  };

  // Reset all filters
  const resetFilters = () => {
    setSearchTerm('');
    setStatusFilter('all');
    setDateRange({
      from: subMonths(new Date(), 1),
      to: new Date()
    });
    setPage(1);
  };

  // Loading state
  if (loading && !payments.length) {
    return (
      <DashboardLayout>
        <div className="flex items-center justify-center h-full p-8">
          <div className="text-center">
            <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary mx-auto mb-4"></div>
            <p className="text-muted-foreground">Loading revenue report data...</p>
            {error && <p className="text-red-500 mt-2">Error: {error}</p>}
          </div>
        </div>
      </DashboardLayout>
    );
  }

  // Calculate pagination
  const paginatedPayments = filteredPayments.slice((page - 1) * pageSize, page * pageSize);

  return (
    <DashboardLayout>
      <div className="flex flex-col gap-6 p-6">
        <div className="flex flex-col md:flex-row justify-between items-start md:items-center">
          <div>
            <h1 className="text-2xl font-bold tracking-tight">Revenue Report</h1>
            <p className="text-muted-foreground">Analyze payment and revenue data</p>
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
            
            <Button variant="outline" onClick={handleExportCSV} disabled={!filteredPayments.length}>
              <Download className="h-4 w-4 mr-2" />
              Export CSV
            </Button>
          </div>
        </div>

        {/* Summary Stats Cards */}
        <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
          {/* Total Revenue Card */}
          <Card>
            <CardHeader className="flex flex-row items-center justify-between pb-2">
              <CardTitle className="text-sm font-medium">Total Revenue</CardTitle>
              <DollarSign className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">{formatCurrency(summaryData.totalRevenue)}</div>
              <p className="text-xs text-muted-foreground mt-1">
                {dateRange.from && dateRange.to ? (
                  `${format(dateRange.from, 'MMM d, yyyy')} - ${format(dateRange.to, 'MMM d, yyyy')}`
                ) : 'All time'}
              </p>
            </CardContent>
          </Card>

          {/* Paid Payments Card */}
          <Card>
            <CardHeader className="flex flex-row items-center justify-between pb-2">
              <CardTitle className="text-sm font-medium">Paid Payments</CardTitle>
              <CreditCard className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">{summaryData.paidPayments}</div>
              <div className="text-xs text-green-500 mt-1">
                {summaryData.totalRecords > 0 ? (
                  `${((summaryData.paidPayments / totalRecords) * 100).toFixed(1)}% of total`
                ) : '0% of total'}
              </div>
            </CardContent>
          </Card>

          {/* Pending Payments Card */}
          <Card>
            <CardHeader className="flex flex-row items-center justify-between pb-2">
              <CardTitle className="text-sm font-medium">Pending Payments</CardTitle>
              <CalendarIcon2 className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">{summaryData.pendingPayments}</div>
              <div className="text-xs text-yellow-500 mt-1">
                {summaryData.totalRecords > 0 ? (
                  `${((summaryData.pendingPayments / totalRecords) * 100).toFixed(1)}% of total`
                ) : '0% of total'}
              </div>
            </CardContent>
          </Card>

          {/* Active Members Card */}
          <Card>
            <CardHeader className="flex flex-row items-center justify-between pb-2">
              <CardTitle className="text-sm font-medium">Paying Members</CardTitle>
              <UsersIcon className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">{totalRecords}</div>
              <p className="text-xs text-muted-foreground mt-1">
                Unique paying customers
              </p>
            </CardContent>
          </Card>
        </div>

        {/* Monthly Revenue Chart */}
        <Card>
          <CardHeader>
            <CardTitle>Monthly Revenue ({selectedYear})</CardTitle>
            <CardDescription>
              Revenue generated from memberships and payments
            </CardDescription>
          </CardHeader>
          <CardContent className="h-80">
            {monthlyRevenue ? (
              <ResponsiveContainer width="100%" height="100%">
                <BarChart
                  data={monthlyRevenue.monthly_data}
                  margin={{ top: 20, right: 30, left: 20, bottom: 30 }}
                >
                  <CartesianGrid strokeDasharray="3 3" />
                  <XAxis dataKey="month_name" />
                  <YAxis tickFormatter={(value) => `${value}`} />
                  <Tooltip formatter={(value) => [`${value}`, 'Revenue']} />
                  <Legend />
                  <Bar dataKey="revenue" name="Revenue" fill="#8884d8" />
                  {monthlyRevenue.previous_year_data && (
                    <Line
                      type="monotone"
                      dataKey={(_, index) => monthlyRevenue.previous_year_data[index]?.revenue || 0}
                      name={`${selectedYear-1} Revenue`}
                      stroke="#82ca9d"
                      strokeDasharray="3 3"
                    />
                  )}
                </BarChart>
              </ResponsiveContainer>
            ) : (
              <div className="flex items-center justify-center h-full">
                <p className="text-muted-foreground">Loading revenue data...</p>
              </div>
            )}
          </CardContent>
        </Card>

        {/* Payments Table */}
        <Card>
          <CardHeader>
            <CardTitle>Payment Records</CardTitle>
            <CardDescription>
              Detailed payment history and transaction records
            </CardDescription>
          </CardHeader>
          <CardContent>
            {/* Filters */}
            <div className="flex flex-col md:flex-row items-start md:items-center justify-between gap-4 mb-6">
              <div className="flex flex-col md:flex-row gap-2 w-full">
                <div className="relative w-full md:max-w-sm">
                  <Search className="absolute left-2.5 top-2.5 h-4 w-4 text-muted-foreground" />
                  <Input
                    placeholder="Search by name, email, or transaction ID..."
                    className="pl-8"
                    value={searchTerm}
                    onChange={(e) => setSearchTerm(e.target.value)}
                  />
                </div>
                
                <Select value={statusFilter} onValueChange={setStatusFilter}>
                  <SelectTrigger className="w-[150px]">
                    <SelectValue placeholder="Payment Status" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="all">All Statuses</SelectItem>
                    <SelectItem value="paid">Paid</SelectItem>
                    <SelectItem value="pending">Pending</SelectItem>
                    <SelectItem value="failed">Failed</SelectItem>
                  </SelectContent>
                </Select>
                
                <Popover open={dateRangeOpen} onOpenChange={setDateRangeOpen}>
                  <PopoverTrigger asChild>
                    <Button variant="outline" className="justify-start text-left font-normal md:w-[300px]">
                      <CalendarIcon className="mr-2 h-4 w-4" />
                      {dateRange.from && dateRange.to ? (
                        <>
                          {format(dateRange.from, 'PPP')} - {format(dateRange.to, 'PPP')}
                        </>
                      ) : (
                        <span>Pick a date range</span>
                      )}
                    </Button>
                  </PopoverTrigger>
                  <PopoverContent className="w-auto p-0" align="start">
                    <Calendar
                      mode="range"
                      defaultMonth={dateRange.from}
                      selected={dateRange}
                      onSelect={handleDateRangeSelect}
                      numberOfMonths={2}
                    />
                  </PopoverContent>
                </Popover>
              </div>
              
              <div className="flex gap-2">
                <Button variant="outline" size="sm" onClick={resetFilters}>
                  Reset Filters
                </Button>
                <Button variant="outline" size="icon" onClick={fetchPayments}>
                  <RefreshCw className="h-4 w-4" />
                </Button>
              </div>
            </div>

            {/* Table */}
            {paginatedPayments.length > 0 ? (
              <div className="rounded-md border overflow-hidden">
                <Table>
                  <TableHeader>
                    <TableRow>
                      <TableHead>ID</TableHead>
                      <TableHead>User</TableHead>
                      <TableHead>Plan</TableHead>
                      <TableHead>Amount</TableHead>
                      <TableHead>Method</TableHead>
                      <TableHead>Date</TableHead>
                      <TableHead>Status</TableHead>
                      <TableHead>Transaction ID</TableHead>
                    </TableRow>
                  </TableHeader>
                  <TableBody>
                    {paginatedPayments.map(payment => (
                      <TableRow key={payment.payment_id}>
                        <TableCell>{payment.payment_id}</TableCell>
                        <TableCell>
                          <div className="font-medium">{payment.users?.full_name || 'Unknown'}</div>
                          <div className="text-xs text-muted-foreground">{payment.users?.email || 'N/A'}</div>
                        </TableCell>
                        <TableCell>
                          {payment.memberships?.membership_plan?.plan_type || 'N/A'}
                        </TableCell>
                        <TableCell className="font-medium">
                          {formatCurrency(payment.price)}
                        </TableCell>
                        <TableCell>
                          <span className="capitalize">{payment.payment_method}</span>
                        </TableCell>
                        <TableCell>
                          {formatDate(payment.payment_date)}
                        </TableCell>
                        <TableCell>
                          <span className={`inline-flex items-center px-2 py-1 rounded-full text-xs font-medium ${getStatusBadgeColor(payment.payment_status)}`}>
                            {payment.payment_status}
                          </span>
                        </TableCell>
                        <TableCell className="font-mono text-xs">
                          {payment.transaction_id || 'N/A'}
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
                <h3 className="mt-4 text-lg font-semibold">No payments found</h3>
                <p className="mt-2 text-sm text-muted-foreground">
                  {searchTerm || statusFilter !== 'all' || (dateRange.from && dateRange.to)
                    ? 'Try adjusting your filters'
                    : 'No payment records available'}
                </p>
                {(searchTerm || statusFilter !== 'all' || (dateRange.from && dateRange.to)) && (
                  <Button 
                    variant="outline" 
                    className="mt-4"
                    onClick={resetFilters}
                  >
                    Reset Filters
                  </Button>
                )}
              </div>
            )}
          </CardContent>
          
          {/* Pagination */}
          {paginatedPayments.length > 0 && (
            <CardFooter className="flex items-center justify-between border-t p-4">
              <div className="text-sm text-muted-foreground">
                Showing {((page - 1) * pageSize) + 1}-{Math.min(page * pageSize, totalRecords)} of {totalRecords} records
              </div>
              
              <div className="flex items-center space-x-6">
                <div className="flex items-center space-x-2">
                  <p className="text-sm font-medium">Rows per page</p>
                  <Select
                    value={pageSize.toString()}
                    onValueChange={(value) => {
                      setPageSize(parseInt(value));
                      setPage(1);
                    }}
                  >
                    <SelectTrigger className="h-8 w-[70px]">
                      <SelectValue placeholder={pageSize} />
                    </SelectTrigger>
                    <SelectContent side="top">
                      {[10, 20, 30, 50, 100].map((size) => (
                        <SelectItem key={size} value={size.toString()}>
                          {size}
                        </SelectItem>
                      ))}
                    </SelectContent>
                  </Select>
                </div>
                
                <div className="flex items-center space-x-2">
                  <Button
                    variant="outline"
                    size="icon"
                    onClick={() => setPage((p) => Math.max(1, p - 1))}
                    disabled={page === 1}
                  >
                    <span className="sr-only">Go to previous page</span>
                    <svg
                      xmlns="http://www.w3.org/2000/svg"
                      width="20"
                      height="20"
                      viewBox="0 0 24 24"
                      fill="none"
                      stroke="currentColor"
                      strokeWidth="2"
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      className="lucide lucide-chevron-left"
                    >
                      <path d="m15 18-6-6 6-6" />
                    </svg>
                  </Button>
                  <div className="flex w-[100px] items-center justify-center text-sm font-medium">
                    Page {page} of {totalPages}
                  </div>
                  <Button
                    variant="outline"
                    size="icon"
                    onClick={() => setPage((p) => Math.min(totalPages, p + 1))}
                    disabled={page === totalPages}
                  >
                    <span className="sr-only">Go to next page</span>
                    <svg
                      xmlns="http://www.w3.org/2000/svg"
                      width="20"
                      height="20"
                      viewBox="0 0 24 24"
                      fill="none"
                      stroke="currentColor"
                      strokeWidth="2"
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      className="lucide lucide-chevron-right"
                    >
                      <path d="m9 18 6-6-6-6" />
                    </svg>
                  </Button>
                </div>
              </div>
            </CardFooter>
          )}
        </Card>
      </div>
    </DashboardLayout>
  );
};

export default RevenueReportPage;