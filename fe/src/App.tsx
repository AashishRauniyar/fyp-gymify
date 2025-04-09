
// import { Toaster } from "@/components/ui/toaster";
// import { Toaster as Sonner } from "@/components/ui/sonner";
// import { TooltipProvider } from "@/components/ui/tooltip";
// import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
// import { BrowserRouter, Routes, Route } from "react-router-dom";
// import Index from "./pages/Index";
// import UsersPage from "./pages/UsersPage";
// import MembershipsPage from "./pages/MembershipsPage";
// import PaymentsPage from "./pages/PaymentsPage";
// import ExercisesPage from "./pages/ExercisesPage";
// import WorkoutsPage from "./pages/WorkoutsPage";
// import NotFound from "./pages/NotFound";
// import LoginPage from "./pages/LoginPage";
// import MembershipPlansPage from "./pages/MembershipPlanPage";
// import RevenueReportPage from "./pages/RevenueReportPage";
// import UserAnalyticsPage from "./pages/UserAnalyticsPage";

// const queryClient = new QueryClient();

// const App = () => (
//   <QueryClientProvider client={queryClient}>
//     <TooltipProvider>
//       <Toaster />
//       <Sonner />
//       <BrowserRouter>
//         <Routes>
//           <Route path="/" element={<LoginPage />} />
//           <Route path="/users" element={<UsersPage />} />
//           <Route path="/memberships" element={<MembershipsPage />} />
//           {/* <Route path="/login" element={<LoginPage />} /> */}
//           <Route path="/dashboard" element={<Index />} />
//           <Route path="/payments" element={<PaymentsPage />} />
//           <Route path="/userAnalytics" element={<UserAnalyticsPage />} />
//           <Route path="/revenue" element={<RevenueReportPage />} />
//           <Route path="/exercises" element={<ExercisesPage />} />
//           <Route path="/workouts" element={<WorkoutsPage />} />
//           <Route path="/MembershipPlans" element={<MembershipPlansPage />} />
//           <Route path="*" element={<NotFound />} />
//         </Routes>
//       </BrowserRouter>
//     </TooltipProvider>
//   </QueryClientProvider>
// );

// export default App;
import { Toaster } from "@/components/ui/toaster";
import { Toaster as Sonner } from "@/components/ui/sonner";
import { TooltipProvider } from "@/components/ui/tooltip";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { BrowserRouter, Routes, Route, Navigate } from "react-router-dom";
import { useEffect, useState } from "react";
import Index from "./pages/Index";
import UsersPage from "./pages/UsersPage";
import MembershipsPage from "./pages/MembershipsPage";
import PaymentsPage from "./pages/PaymentsPage";
import ExercisesPage from "./pages/ExercisesPage";
import WorkoutsPage from "./pages/WorkoutsPage";
import NotFound from "./pages/NotFound";
import LoginPage from "./pages/LoginPage";
import ProfilePage from "./pages/AdminProfilePage";
import MembershipPlansPage from "./pages/MembershipPlanPage";
import RevenueReportPage from "./pages/RevenueReportPage";
import UserAnalyticsPage from "./pages/UserAnalyticsPage";

const queryClient = new QueryClient();

// Protected Route component that checks for authentication
const ProtectedRoute = ({ children }) => {
  const token = localStorage.getItem('token');
  
  if (!token) {
    // Redirect to login if no token is found
    return <Navigate to="/login" replace />;
  }
  
  return children;
};

// Public Route component that redirects to dashboard if already authenticated
const PublicRoute = ({ children }) => {
  const token = localStorage.getItem('token');
  
  if (token) {
    // Redirect to dashboard if already logged in
    return <Navigate to="/dashboard" replace />;
  }
  
  return children;
};

const App = () => {
  const [isLoading, setIsLoading] = useState(true);

  // Check token validity when app loads
  useEffect(() => {
    const checkAuth = async () => {
      try {
        // Optional: Verify token with backend
        // const token = localStorage.getItem('token');
        // if (token) {
        //   await userInstance.get('/auth/verify-token');
        // }
      } catch (error) {
        // If token verification fails, clear it
        localStorage.removeItem('token');
      } finally {
        setIsLoading(false);
      }
    };

    checkAuth();
  }, []);

  if (isLoading) {
    return <div className="flex justify-center items-center min-h-screen">Loading...</div>;
  }

  return (
    <QueryClientProvider client={queryClient}>
      <TooltipProvider>
        <Toaster />
        <Sonner />
        <BrowserRouter>
          <Routes>
            {/* Redirect root to dashboard (which will check for auth) */}
            <Route path="/" element={<Navigate to="/dashboard" replace />} />
            
            {/* Public route - Login page (redirects to dashboard if already logged in) */}
            <Route path="/login" element={
              <PublicRoute>
                <LoginPage />
              </PublicRoute>
            } />
            
            {/* Protected routes - Only accessible when logged in */}
            <Route path="/dashboard" element={
              <ProtectedRoute>
                <Index />
              </ProtectedRoute>
            } />
            <Route path="/profile" element={
              <ProtectedRoute>
                <ProfilePage />
              </ProtectedRoute>
            } />
            <Route path="/users" element={
              <ProtectedRoute>
                <UsersPage />
              </ProtectedRoute>
            } />
            <Route path="/memberships" element={
              <ProtectedRoute>
                <MembershipsPage />
              </ProtectedRoute>
            } />
            <Route path="/payments" element={
              <ProtectedRoute>
                <PaymentsPage />
              </ProtectedRoute>
            } />
            <Route path="/userAnalytics" element={
              <ProtectedRoute>
                <UserAnalyticsPage />
              </ProtectedRoute>
            } />
            <Route path="/revenue" element={
              <ProtectedRoute>
                <RevenueReportPage />
              </ProtectedRoute>
            } />
            <Route path="/exercises" element={
              <ProtectedRoute>
                <ExercisesPage />
              </ProtectedRoute>
            } />
            <Route path="/workouts" element={
              <ProtectedRoute>
                <WorkoutsPage />
              </ProtectedRoute>
            } />
            <Route path="/MembershipPlans" element={
              <ProtectedRoute>
                <MembershipPlansPage />
              </ProtectedRoute>
            } />
            
            {/* Catch-all route */}
            <Route path="*" element={<NotFound />} />
          </Routes>
        </BrowserRouter>
      </TooltipProvider>
    </QueryClientProvider>
  );
};

export default App;