import React, { useEffect, useState } from 'react';
import { useNavigate, useLocation } from 'react-router-dom';
import { userInstance } from '@/network/axios';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from '@/components/ui/card';
import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar';
import { Label } from '@/components/ui/label';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { toast } from "@/components/ui/use-toast";
import { Loader2 } from "lucide-react";

// Main ProfilePage component
const ProfilePage = () => {
  const navigate = useNavigate();
  const location = useLocation();
  const [activeTab, setActiveTab] = useState('info');
  const [isLoading, setIsLoading] = useState(true);
  const [profileData, setProfileData] = useState({
    user_id: '',
    user_name: '',
    full_name: '',
    email: '',
    phone_number: '',
    role: '',
    created_at: '',
    profile_image: '',
  });

  // Password reset states
  const [resetStep, setResetStep] = useState('request'); // 'request', 'verify', 'success'
  const [resetEmail, setResetEmail] = useState('');
  const [otp, setOtp] = useState('');
  const [newPassword, setNewPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [isSubmitting, setIsSubmitting] = useState(false);

  // Set active tab based on URL query parameter
  useEffect(() => {
    const params = new URLSearchParams(location.search);
    const tabParam = params.get('tab');
    if (tabParam === 'security') {
      setActiveTab('security');
    }
  }, [location]);

  // Fetch profile data
  useEffect(() => {
    const fetchProfileData = async () => {
      try {
        setIsLoading(true);
        const response = await userInstance.get('/profile');
        
        if (response.data.status === 'success') {
          setProfileData(response.data.data);
          setResetEmail(response.data.data.email || '');
        }
      } catch (error) {
        console.error('Error fetching profile:', error);
        toast({
          title: "Error",
          description: "Failed to load profile data",
          variant: "destructive",
        });
        
        // If unauthorized, redirect to login
        if (error.response?.status === 401) {
          localStorage.removeItem('token');
          navigate('/');
        }
      } finally {
        setIsLoading(false);
      }
    };

    fetchProfileData();
  }, [navigate]);

  // Request password reset OTP
  const handleRequestOTP = async (e) => {
    e.preventDefault();
    setIsSubmitting(true);
    
    try {
      const response = await userInstance.post('/auth/forgot-password', { email: resetEmail });
      
      if (response.data.status === 'success') {
        setResetStep('verify');
        toast({
          title: "Success",
          description: "OTP sent to your email",
        });
      }
    } catch (error) {
      console.error('Error requesting OTP:', error);
      toast({
        title: "Error",
        description: error.response?.data?.message || "Failed to send OTP",
        variant: "destructive",
      });
    } finally {
      setIsSubmitting(false);
    }
  };

  // Verify OTP and reset password
  const handleResetPassword = async (e) => {
    e.preventDefault();
    
    // Validate passwords match
    if (newPassword !== confirmPassword) {
      toast({
        title: "Error",
        description: "Passwords don't match",
        variant: "destructive",
      });
      return;
    }

    // Validate password strength
    const passwordRegex = /^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;
    if (!passwordRegex.test(newPassword)) {
      toast({
        title: "Error",
        description: "Password must be at least 8 characters with at least one uppercase letter, lowercase letter, number, and special character",
        variant: "destructive",
      });
      return;
    }

    setIsSubmitting(true);
    
    try {
      const response = await userInstance.post('/auth/reset-password', {
        email: resetEmail,
        otp: otp,
        newPassword: newPassword
      });
      
      if (response.data.status === 'success') {
        setResetStep('success');
        // Clear form fields
        setOtp('');
        setNewPassword('');
        setConfirmPassword('');
        
        toast({
          title: "Success",
          description: "Password reset successfully",
        });
      }
    } catch (error) {
      console.error('Error resetting password:', error);
      toast({
        title: "Error",
        description: error.response?.data?.message || "Failed to reset password",
        variant: "destructive",
      });
    } finally {
      setIsSubmitting(false);
    }
  };

  // Reset the form
  const handleResetForm = () => {
    setResetStep('request');
    setOtp('');
    setNewPassword('');
    setConfirmPassword('');
  };

  if (isLoading) {
    return <div className="flex justify-center items-center min-h-screen">Loading profile...</div>;
  }

  return (
    <div className="container mx-auto py-6">
      <div className="flex flex-col">
        <h1 className="text-2xl font-bold mb-6">Admin Profile</h1>
        
        <Tabs value={activeTab} onValueChange={setActiveTab} className="w-full">
          <TabsList className="mb-4">
            <TabsTrigger value="info">Profile Information</TabsTrigger>
            <TabsTrigger value="security">Security</TabsTrigger>
          </TabsList>
          
          {/* Profile Information Tab */}
          <TabsContent value="info">
            <div className="grid grid-cols-1 md:grid-cols-1 gap-6 max-w-xl mx-auto">
              {/* Profile Card */}
              <Card>
                <CardHeader className="flex flex-col items-center">
                  <Avatar className="h-24 w-24 mb-4">
                    {profileData.profile_image ? (
                      <AvatarImage src={profileData.profile_image} alt={profileData.full_name} />
                    ) : (
                      <AvatarFallback className="text-xl">{profileData.full_name?.substring(0, 2).toUpperCase() || 'AD'}</AvatarFallback>
                    )}
                  </Avatar>
                  <CardTitle>{profileData.full_name || 'Admin'}</CardTitle>
                  <CardDescription>{profileData.email}</CardDescription>
                </CardHeader>
                <CardContent className="space-y-4">
                  <div className="grid grid-cols-2 gap-4">
                    <div>
                      <div className="text-sm font-medium text-muted-foreground">User ID</div>
                      <div className="font-medium">{profileData.user_id}</div>
                    </div>
                    <div>
                      <div className="text-sm font-medium text-muted-foreground">Username</div>
                      <div className="font-medium">{profileData.user_name}</div>
                    </div>
                  </div>
                  
                  <div className="grid grid-cols-2 gap-4">
                    <div>
                      <div className="text-sm font-medium text-muted-foreground">Role</div>
                      <div className="font-medium capitalize">{profileData.role || 'Admin'}</div>
                    </div>
                    <div>
                      <div className="text-sm font-medium text-muted-foreground">Phone</div>
                      <div className="font-medium">{profileData.phone_number || 'Not provided'}</div>
                    </div>
                  </div>
                  
                  <div>
                    <div className="text-sm font-medium text-muted-foreground">Account Created</div>
                    <div className="font-medium">{profileData.created_at ? new Date(profileData.created_at).toLocaleDateString() : 'Unknown'}</div>
                  </div>
                </CardContent>
              </Card>
            </div>
          </TabsContent>
          
          {/* Password Reset Tab */}
          <TabsContent value="security">
            <div className="grid grid-cols-1 md:grid-cols-1 gap-6 max-w-xl mx-auto">
              <Card>
                <CardHeader>
                  <CardTitle>Reset Password</CardTitle>
                  <CardDescription>
                    {resetStep === 'request' && "We'll send a one-time password (OTP) to your email"}
                    {resetStep === 'verify' && "Enter the OTP sent to your email and your new password"}
                    {resetStep === 'success' && "Your password has been reset successfully"}
                  </CardDescription>
                </CardHeader>
                <CardContent>
                  {resetStep === 'request' && (
                    <form onSubmit={handleRequestOTP} className="space-y-4">
                      <div className="space-y-2">
                        <Label htmlFor="email">Email</Label>
                        <Input 
                          id="email" 
                          type="email"
                          value={resetEmail} 
                          onChange={(e) => setResetEmail(e.target.value)} 
                          placeholder="Enter your email" 
                          required
                          disabled={isSubmitting}
                        />
                      </div>
                      
                      <Button type="submit" className="w-full" disabled={isSubmitting}>
                        {isSubmitting ? (
                          <>
                            <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                            Sending OTP...
                          </>
                        ) : "Send OTP"}
                      </Button>
                    </form>
                  )}
                  
                  {resetStep === 'verify' && (
                    <form onSubmit={handleResetPassword} className="space-y-4">
                      <div className="space-y-2">
                        <Label htmlFor="otp">One-Time Password (OTP)</Label>
                        <Input 
                          id="otp" 
                          value={otp} 
                          onChange={(e) => setOtp(e.target.value)} 
                          placeholder="Enter OTP from email" 
                          required
                          disabled={isSubmitting}
                        />
                      </div>
                      
                      <div className="space-y-2">
                        <Label htmlFor="newPassword">New Password</Label>
                        <Input 
                          id="newPassword" 
                          type="password"
                          value={newPassword} 
                          onChange={(e) => setNewPassword(e.target.value)} 
                          placeholder="Enter new password" 
                          required
                          disabled={isSubmitting}
                        />
                        <p className="text-xs text-muted-foreground">
                          Password must be at least 8 characters with at least one uppercase letter, 
                          lowercase letter, number, and special character.
                        </p>
                      </div>
                      
                      <div className="space-y-2">
                        <Label htmlFor="confirmPassword">Confirm Password</Label>
                        <Input 
                          id="confirmPassword" 
                          type="password"
                          value={confirmPassword} 
                          onChange={(e) => setConfirmPassword(e.target.value)} 
                          placeholder="Confirm new password" 
                          required
                          disabled={isSubmitting}
                        />
                      </div>
                      
                      <div className="flex flex-col space-y-2">
                        <Button type="submit" disabled={isSubmitting}>
                          {isSubmitting ? (
                            <>
                              <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                              Resetting Password...
                            </>
                          ) : "Reset Password"}
                        </Button>
                        <Button 
                          type="button" 
                          variant="outline" 
                          onClick={handleRequestOTP} 
                          disabled={isSubmitting}
                        >
                          Resend OTP
                        </Button>
                      </div>
                    </form>
                  )}
                  
                  {resetStep === 'success' && (
                    <div className="space-y-4">
                      <div className="bg-green-50 text-green-800 rounded-lg p-4">
                        <p className="font-medium">Password Reset Successful</p>
                        <p className="text-sm mt-1">Your password has been changed successfully.</p>
                      </div>
                      
                      <Button onClick={handleResetForm} className="w-full">
                        Reset Another Password
                      </Button>
                    </div>
                  )}
                </CardContent>
              </Card>
            </div>
          </TabsContent>
        </Tabs>
      </div>
    </div>
  );
};

export default ProfilePage;