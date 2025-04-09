// import React, { useState } from 'react';
// import {
//   Dialog,
//   DialogContent,
//   DialogDescription,
//   DialogFooter,
//   DialogHeader,
//   DialogTitle,
//   DialogTrigger,
// } from "@/components/ui/dialog";
// import {
//   Form,
//   FormControl,
//   FormDescription,
//   FormField,
//   FormItem,
//   FormLabel,
//   FormMessage,
// } from "@/components/ui/form";
// import {
//   Select,
//   SelectContent,
//   SelectItem,
//   SelectTrigger,
//   SelectValue,
// } from "@/components/ui/select";
// import { Input } from "@/components/ui/input";
// import { Button } from "@/components/ui/button";
// import { Textarea } from "@/components/ui/textarea";
// import { Plus, Loader2 } from 'lucide-react';
// import { userInstance } from '@/network/axios';
// import { useToast } from "@/components/ui/use-toast";
// import { zodResolver } from '@hookform/resolvers/zod';
// import { useForm } from 'react-hook-form';
// import * as z from 'zod';

// // Form validation schema
// const formSchema = z.object({
//   email: z.string().email({ message: "Please enter a valid email address" }),
//   password: z
//     .string()
//     .min(8, { message: "Password must be at least 8 characters long" })
//     .regex(
//       /^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/,
//       {
//         message: "Password must include uppercase, lowercase, number, and special character",
//       }
//     ),
//   user_name: z
//     .string()
//     .min(3, { message: "Username must be at least 3 characters long" })
//     .regex(/^[a-zA-Z0-9_]+$/, {
//       message: "Username can only contain letters, numbers, and underscores",
//     }),
//   full_name: z.string().optional(),
//   phone_number: z.string().optional(),
//   role: z.enum(["Admin", "Trainer", "Member"]),
//   address: z.string().optional(),
//   gender: z.enum(["Male", "Female", "Other"]).optional(),
//   birthdate: z.string().optional(),
//   height: z.string().optional(),
//   current_weight: z.string().optional(),
//   fitness_level: z.enum(["Beginner", "Intermediate", "Advanced", "Athlete"]).optional(),
//   goal_type: z.enum(["Weight_Loss", "Muscle_Gain", "Endurance", "Maintenance", "Flexibility"]).optional(),
//   allergies: z.string().optional(),
//   calorie_goals: z.string().optional(),
//   card_number: z.string().optional(),
// });

// const RegisterUserDialog = ({ onSuccess }) => {
//   const [open, setOpen] = useState(false);
//   const [loading, setLoading] = useState(false);
//   const { toast } = useToast();

//   const form = useForm({
//     resolver: zodResolver(formSchema),
//     defaultValues: {
//       email: "",
//       password: "",
//       user_name: "",
//       full_name: "",
//       phone_number: "",
//       role: "Member",
//       address: "",
//       gender: undefined,
//       birthdate: "",
//       height: "",
//       current_weight: "",
//       fitness_level: undefined,
//       goal_type: undefined,
//       allergies: "",
//       calorie_goals: "",
//       card_number: "",
//     },
//   });

//   const handleSubmit = async (data) => {
//     setLoading(true);
//     try {
//       const response = await userInstance.post('/admin/users/register', data);
      
//       toast({
//         title: "Success",
//         description: "User registered successfully",
//         variant: "default",
//       });
      
//       setOpen(false);
//       form.reset();
      
//       // Call success callback if provided (to refresh user list)
//       if (onSuccess) {
//         onSuccess();
//       }
//     } catch (error) {
//       console.error('Error registering user:', error);
      
//       // Handle different error cases
//       if (error.response?.data?.message) {
//         toast({
//           title: "Registration Failed",
//           description: error.response.data.message,
//           variant: "destructive",
//         });
//       } else {
//         toast({
//           title: "Registration Failed",
//           description: "An unexpected error occurred. Please try again.",
//           variant: "destructive",
//         });
//       }
//     } finally {
//       setLoading(false);
//     }
//   };

//   return (
//     <Dialog open={open} onOpenChange={setOpen}>
//       <DialogTrigger asChild>
//         <Button className="flex items-center gap-2">
//           <Plus className="h-4 w-4" />
//           Add New User
//         </Button>
//       </DialogTrigger>
//       <DialogContent className="max-w-3xl max-h-[90vh] overflow-y-auto">
//         <DialogHeader>
//           <DialogTitle>Register New User</DialogTitle>
//           <DialogDescription>
//             Create a new user account. Required fields are marked with an asterisk (*).
//           </DialogDescription>
//         </DialogHeader>

//         <Form {...form}>
//           <form onSubmit={form.handleSubmit(handleSubmit)} className="space-y-6">
//             <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
//               {/* Required Fields Section */}
//               <div className="space-y-4 md:col-span-2">
//                 <h3 className="text-lg font-medium">Account Information</h3>
//                 <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
//                   <FormField
//                     control={form.control}
//                     name="email"
//                     render={({ field }) => (
//                       <FormItem>
//                         <FormLabel>Email *</FormLabel>
//                         <FormControl>
//                           <Input {...field} placeholder="user@example.com" />
//                         </FormControl>
//                         <FormMessage />
//                       </FormItem>
//                     )}
//                   />
                  
//                   <FormField
//                     control={form.control}
//                     name="password"
//                     render={({ field }) => (
//                       <FormItem>
//                         <FormLabel>Password *</FormLabel>
//                         <FormControl>
//                           <Input 
//                             {...field} 
//                             type="password" 
//                             placeholder="●●●●●●●●" 
//                           />
//                         </FormControl>
//                         <FormDescription>
//                           Min 8 chars, with uppercase, lowercase, number & special char
//                         </FormDescription>
//                         <FormMessage />
//                       </FormItem>
//                     )}
//                   />
//                 </div>
//               </div>
              
//               <FormField
//                 control={form.control}
//                 name="user_name"
//                 render={({ field }) => (
//                   <FormItem>
//                     <FormLabel>Username *</FormLabel>
//                     <FormControl>
//                       <Input {...field} placeholder="username" />
//                     </FormControl>
//                     <FormMessage />
//                   </FormItem>
//                 )}
//               />
              
//               <FormField
//                 control={form.control}
//                 name="role"
//                 render={({ field }) => (
//                   <FormItem>
//                     <FormLabel>Role *</FormLabel>
//                     <Select 
//                       onValueChange={field.onChange} 
//                       defaultValue={field.value}
//                     >
//                       <FormControl>
//                         <SelectTrigger>
//                           <SelectValue placeholder="Select role" />
//                         </SelectTrigger>
//                       </FormControl>
//                       <SelectContent>
//                         <SelectItem value="Member">Member</SelectItem>
//                         <SelectItem value="Trainer">Trainer</SelectItem>
//                         <SelectItem value="Admin">Admin</SelectItem>
//                       </SelectContent>
//                     </Select>
//                     <FormMessage />
//                   </FormItem>
//                 )}
//               />
              
//               {/* Personal Information Section */}
//               <div className="space-y-4 md:col-span-2">
//                 <h3 className="text-lg font-medium">Personal Information</h3>
//                 <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
//                   <FormField
//                     control={form.control}
//                     name="full_name"
//                     render={({ field }) => (
//                       <FormItem>
//                         <FormLabel>Full Name</FormLabel>
//                         <FormControl>
//                           <Input {...field} placeholder="John Doe" />
//                         </FormControl>
//                         <FormMessage />
//                       </FormItem>
//                     )}
//                   />
                  
//                   <FormField
//                     control={form.control}
//                     name="phone_number"
//                     render={({ field }) => (
//                       <FormItem>
//                         <FormLabel>Phone Number</FormLabel>
//                         <FormControl>
//                           <Input {...field} placeholder="+1234567890" />
//                         </FormControl>
//                         <FormMessage />
//                       </FormItem>
//                     )}
//                   />
                  
//                   <FormField
//                     control={form.control}
//                     name="gender"
//                     render={({ field }) => (
//                       <FormItem>
//                         <FormLabel>Gender</FormLabel>
//                         <Select 
//                           onValueChange={field.onChange} 
//                           defaultValue={field.value}
//                         >
//                           <FormControl>
//                             <SelectTrigger>
//                               <SelectValue placeholder="Select gender" />
//                             </SelectTrigger>
//                           </FormControl>
//                           <SelectContent>
//                             <SelectItem value="Male">Male</SelectItem>
//                             <SelectItem value="Female">Female</SelectItem>
//                             <SelectItem value="Other">Other</SelectItem>
//                           </SelectContent>
//                         </Select>
//                         <FormMessage />
//                       </FormItem>
//                     )}
//                   />
                  
//                   <FormField
//                     control={form.control}
//                     name="birthdate"
//                     render={({ field }) => (
//                       <FormItem>
//                         <FormLabel>Birthdate</FormLabel>
//                         <FormControl>
//                           <Input type="date" {...field} />
//                         </FormControl>
//                         <FormMessage />
//                       </FormItem>
//                     )}
//                   />
                  
//                   <FormField
//                     control={form.control}
//                     name="address"
//                     render={({ field }) => (
//                       <FormItem className="md:col-span-2">
//                         <FormLabel>Address</FormLabel>
//                         <FormControl>
//                           <Textarea 
//                             {...field} 
//                             placeholder="Enter address"
//                             rows={2}
//                           />
//                         </FormControl>
//                         <FormMessage />
//                       </FormItem>
//                     )}
//                   />
//                 </div>
//               </div>

//               {/* Fitness Information Section */}
//               <div className="space-y-4 md:col-span-2">
//                 <h3 className="text-lg font-medium">Fitness Information</h3>
//                 <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
//                   <FormField
//                     control={form.control}
//                     name="fitness_level"
//                     render={({ field }) => (
//                       <FormItem>
//                         <FormLabel>Fitness Level</FormLabel>
//                         <Select 
//                           onValueChange={field.onChange} 
//                           defaultValue={field.value}
//                         >
//                           <FormControl>
//                             <SelectTrigger>
//                               <SelectValue placeholder="Select fitness level" />
//                             </SelectTrigger>
//                           </FormControl>
//                           <SelectContent>
//                             <SelectItem value="Beginner">Beginner</SelectItem>
//                             <SelectItem value="Intermediate">Intermediate</SelectItem>
//                             <SelectItem value="Advanced">Advanced</SelectItem>
//                             <SelectItem value="Athlete">Athlete</SelectItem>
//                           </SelectContent>
//                         </Select>
//                         <FormMessage />
//                       </FormItem>
//                     )}
//                   />
                  
//                   <FormField
//                     control={form.control}
//                     name="goal_type"
//                     render={({ field }) => (
//                       <FormItem>
//                         <FormLabel>Goal Type</FormLabel>
//                         <Select 
//                           onValueChange={field.onChange} 
//                           defaultValue={field.value}
//                         >
//                           <FormControl>
//                             <SelectTrigger>
//                               <SelectValue placeholder="Select goal type" />
//                             </SelectTrigger>
//                           </FormControl>
//                           <SelectContent>
//                             <SelectItem value="Weight_Loss">Weight Loss</SelectItem>
//                             <SelectItem value="Muscle_Gain">Muscle Gain</SelectItem>
//                             <SelectItem value="Endurance">Endurance</SelectItem>
//                             <SelectItem value="Maintenance">Maintenance</SelectItem>
//                             <SelectItem value="Flexibility">Flexibility</SelectItem>
//                           </SelectContent>
//                         </Select>
//                         <FormMessage />
//                       </FormItem>
//                     )}
//                   />
                  
//                   <FormField
//                     control={form.control}
//                     name="height"
//                     render={({ field }) => (
//                       <FormItem>
//                         <FormLabel>Height (cm)</FormLabel>
//                         <FormControl>
//                           <Input {...field} type="number" placeholder="175" />
//                         </FormControl>
//                         <FormMessage />
//                       </FormItem>
//                     )}
//                   />
                  
//                   <FormField
//                     control={form.control}
//                     name="current_weight"
//                     render={({ field }) => (
//                       <FormItem>
//                         <FormLabel>Current Weight (kg)</FormLabel>
//                         <FormControl>
//                           <Input {...field} type="number" placeholder="70" />
//                         </FormControl>
//                         <FormMessage />
//                       </FormItem>
//                     )}
//                   />
                  
//                   <FormField
//                     control={form.control}
//                     name="calorie_goals"
//                     render={({ field }) => (
//                       <FormItem>
//                         <FormLabel>Calorie Goals</FormLabel>
//                         <FormControl>
//                           <Input {...field} type="number" placeholder="2000" />
//                         </FormControl>
//                         <FormMessage />
//                       </FormItem>
//                     )}
//                   />
                  
//                   <FormField
//                     control={form.control}
//                     name="card_number"
//                     render={({ field }) => (
//                       <FormItem>
//                         <FormLabel>Card Number</FormLabel>
//                         <FormControl>
//                           <Input {...field} placeholder="Enter RFID card number" />
//                         </FormControl>
//                         <FormMessage />
//                       </FormItem>
//                     )}
//                   />
                  
//                   <FormField
//                     control={form.control}
//                     name="allergies"
//                     render={({ field }) => (
//                       <FormItem className="md:col-span-2">
//                         <FormLabel>Allergies</FormLabel>
//                         <FormControl>
//                           <Textarea 
//                             {...field} 
//                             placeholder="Enter any allergies or dietary restrictions"
//                             rows={2}
//                           />
//                         </FormControl>
//                         <FormMessage />
//                       </FormItem>
//                     )}
//                   />
//                 </div>
//               </div>
//             </div>

//             <DialogFooter>
//               <Button type="button" variant="outline" onClick={() => setOpen(false)}>
//                 Cancel
//               </Button>
//               <Button type="submit" disabled={loading}>
//                 {loading && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
//                 Register User
//               </Button>
//             </DialogFooter>
//           </form>
//         </Form>
//       </DialogContent>
//     </Dialog>
//   );
// };

// export default RegisterUserDialog;


import React, { useState, useRef } from 'react';
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
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Textarea } from "@/components/ui/textarea";
import { Plus, Loader2, Upload, X } from 'lucide-react';
import { userInstance } from '@/network/axios';
import { useToast } from "@/components/ui/use-toast";
import { zodResolver } from '@hookform/resolvers/zod';
import { useForm } from 'react-hook-form';
import * as z from 'zod';
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";

// Form validation schema
const formSchema = z.object({
  email: z.string().email({ message: "Please enter a valid email address" }),
  password: z
    .string()
    .min(8, { message: "Password must be at least 8 characters long" })
    .regex(
      /^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/,
      {
        message: "Password must include uppercase, lowercase, number, and special character",
      }
    ),
  user_name: z
    .string()
    .min(3, { message: "Username must be at least 3 characters long" })
    .regex(/^[a-zA-Z0-9_]+$/, {
      message: "Username can only contain letters, numbers, and underscores",
    }),
  full_name: z.string().optional(),
  phone_number: z.string().optional(),
  role: z.enum(["Admin", "Trainer", "Member"]),
  address: z.string().optional(),
  gender: z.enum(["Male", "Female", "Other"]).optional(),
  birthdate: z.string().optional(),
  height: z.string().optional(),
  current_weight: z.string().optional(),
  fitness_level: z.enum(["Beginner", "Intermediate", "Advanced", "Athlete"]).optional(),
  goal_type: z.enum(["Weight_Loss", "Muscle_Gain", "Endurance", "Maintenance", "Flexibility"]).optional(),
  allergies: z.string().optional(),
  calorie_goals: z.string().optional(),
  card_number: z.string().optional(),
  // Image isn't included in the schema as it will be handled separately
});

const RegisterUserDialog = ({ onSuccess }) => {
  const [open, setOpen] = useState(false);
  const [loading, setLoading] = useState(false);
  const [profileImage, setProfileImage] = useState(null);
  const [previewUrl, setPreviewUrl] = useState('');
  const fileInputRef = useRef(null);
  const { toast } = useToast();

  const form = useForm({
    resolver: zodResolver(formSchema),
    defaultValues: {
      email: "",
      password: "",
      user_name: "",
      full_name: "",
      phone_number: "",
      role: "Member",
      address: "",
      gender: undefined,
      birthdate: "",
      height: "",
      current_weight: "",
      fitness_level: undefined,
      goal_type: undefined,
      allergies: "",
      calorie_goals: "",
      card_number: "",
    },
  });

  const handleImageChange = (e) => {
    const file = e.target.files[0];
    if (file) {
      setProfileImage(file);
      // Create preview URL
      const reader = new FileReader();
      reader.onloadend = () => {
        setPreviewUrl(reader.result);
      };
      reader.readAsDataURL(file);
    }
  };

  const clearImage = () => {
    setProfileImage(null);
    setPreviewUrl('');
    if (fileInputRef.current) {
      fileInputRef.current.value = '';
    }
  };

  // Default avatar URL - replace with your actual default avatar URL
  const defaultAvatarUrl = "https://res.cloudinary.com/dqcdosfch/image/upload/v1743757651/profile_images/wwp2kkuwohoh7ejkmq7s.png";
  
  const handleSubmit = async (data) => {
    setLoading(true);
    try {
      // Create FormData object to handle file upload
      const formData = new FormData();
      
      // Append all form data
      Object.keys(data).forEach(key => {
        formData.append(key, data[key]);
      });
      
      // If no profile image is selected, fetch the default avatar and append it
      if (profileImage) {
        formData.append('profile_image', profileImage);
      } else {
        try {
          // Fetch the default avatar image
          const response = await fetch(defaultAvatarUrl);
          const blob = await response.blob();
          
          // Create a File object from the blob
          const defaultImageFile = new File([blob], "default-avatar.png", { type: "image/png" });
          
          // Append the default image file
          formData.append('profile_image', defaultImageFile);
        } catch (error) {
          console.error("Error fetching default avatar:", error);
          // If fetching default avatar fails, continue without an image
        }
      }
      
      // Make a multipart/form-data request
      const response = await userInstance.post('/admin/users/register', formData, {
        headers: {
          'Content-Type': 'multipart/form-data'
        }
      });
      
      toast({
        title: "Success",
        description: "User registered successfully",
        variant: "default",
      });
      
      setOpen(false);
      form.reset();
      clearImage();
      
      // Call success callback if provided (to refresh user list)
      if (onSuccess) {
        onSuccess();
      }
    } catch (error) {
      console.error('Error registering user:', error);
      
      // Handle different error cases
      if (error.response?.data?.message) {
        toast({
          title: "Registration Failed",
          description: error.response.data.message,
          variant: "destructive",
        });
      } else {
        toast({
          title: "Registration Failed",
          description: "An unexpected error occurred. Please try again.",
          variant: "destructive",
        });
      }
    } finally {
      setLoading(false);
    }
  };

  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <DialogTrigger asChild>
        <Button className="flex items-center gap-2">
          <Plus className="h-4 w-4" />
          Add New User
        </Button>
      </DialogTrigger>
      <DialogContent className="max-w-3xl max-h-[90vh] overflow-y-auto">
        <DialogHeader>
          <DialogTitle>Register New User</DialogTitle>
          <DialogDescription>
            Create a new user account. Required fields are marked with an asterisk (*).
          </DialogDescription>
        </DialogHeader>

        <Form {...form}>
          <form onSubmit={form.handleSubmit(handleSubmit)} className="space-y-6">
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              {/* Profile Image Section */}
              <div className="space-y-4 md:col-span-2 flex flex-col items-center">
                <h3 className="text-lg font-medium self-start">Profile Image</h3>
                <div className="flex flex-col items-center gap-4">
                  <Avatar className="h-24 w-24">
                    <AvatarImage src={previewUrl} alt="Profile preview" />
                    <AvatarFallback>
                      {form.watch("full_name") 
                        ? form.watch("full_name").charAt(0).toUpperCase() 
                        : form.watch("user_name")
                          ? form.watch("user_name").charAt(0).toUpperCase()
                          : "U"}
                    </AvatarFallback>
                  </Avatar>
                  
                  <div className="flex gap-2">
                    <Button 
                      type="button" 
                      variant="outline" 
                      size="sm"
                      onClick={() => fileInputRef.current?.click()}
                    >
                      <Upload className="h-4 w-4 mr-2" />
                      {previewUrl ? "Change Image" : "Upload Image"}
                    </Button>
                    
                    {previewUrl && (
                      <Button 
                        type="button" 
                        variant="outline" 
                        size="sm"
                        onClick={clearImage}
                      >
                        <X className="h-4 w-4 mr-2" />
                        Remove
                      </Button>
                    )}
                    
                    <input
                      type="file"
                      ref={fileInputRef}
                      onChange={handleImageChange}
                      className="hidden"
                      accept="image/*"
                    />
                  </div>
                  
                  <FormDescription className="text-center">
                    Upload a profile image (optional). If not provided, a default image will be used.
                  </FormDescription>
                </div>
              </div>
              
              {/* Required Fields Section */}
              <div className="space-y-4 md:col-span-2">
                <h3 className="text-lg font-medium">Account Information</h3>
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <FormField
                    control={form.control}
                    name="email"
                    render={({ field }) => (
                      <FormItem>
                        <FormLabel>Email *</FormLabel>
                        <FormControl>
                          <Input {...field} placeholder="user@example.com" />
                        </FormControl>
                        <FormMessage />
                      </FormItem>
                    )}
                  />
                  
                  <FormField
                    control={form.control}
                    name="password"
                    render={({ field }) => (
                      <FormItem>
                        <FormLabel>Password *</FormLabel>
                        <FormControl>
                          <Input 
                            {...field} 
                            type="password" 
                            placeholder="●●●●●●●●" 
                          />
                        </FormControl>
                        <FormDescription>
                          Min 8 chars, with uppercase, lowercase, number & special char
                        </FormDescription>
                        <FormMessage />
                      </FormItem>
                    )}
                  />
                </div>
              </div>
              
              <FormField
                control={form.control}
                name="user_name"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Username *</FormLabel>
                    <FormControl>
                      <Input {...field} placeholder="username" />
                    </FormControl>
                    <FormMessage />
                  </FormItem>
                )}
              />
              
              <FormField
                control={form.control}
                name="role"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Role *</FormLabel>
                    <Select 
                      onValueChange={field.onChange} 
                      defaultValue={field.value}
                    >
                      <FormControl>
                        <SelectTrigger>
                          <SelectValue placeholder="Select role" />
                        </SelectTrigger>
                      </FormControl>
                      <SelectContent>
                        <SelectItem value="Member">Member</SelectItem>
                        <SelectItem value="Trainer">Trainer</SelectItem>
                        <SelectItem value="Admin">Admin</SelectItem>
                      </SelectContent>
                    </Select>
                    <FormMessage />
                  </FormItem>
                )}
              />
              
              {/* Personal Information Section */}
              <div className="space-y-4 md:col-span-2">
                <h3 className="text-lg font-medium">Personal Information</h3>
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <FormField
                    control={form.control}
                    name="full_name"
                    render={({ field }) => (
                      <FormItem>
                        <FormLabel>Full Name</FormLabel>
                        <FormControl>
                          <Input {...field} placeholder="John Doe" />
                        </FormControl>
                        <FormMessage />
                      </FormItem>
                    )}
                  />
                  
                  <FormField
                    control={form.control}
                    name="phone_number"
                    render={({ field }) => (
                      <FormItem>
                        <FormLabel>Phone Number</FormLabel>
                        <FormControl>
                          <Input {...field} placeholder="+1234567890" />
                        </FormControl>
                        <FormMessage />
                      </FormItem>
                    )}
                  />
                  
                  <FormField
                    control={form.control}
                    name="gender"
                    render={({ field }) => (
                      <FormItem>
                        <FormLabel>Gender</FormLabel>
                        <Select 
                          onValueChange={field.onChange} 
                          defaultValue={field.value}
                        >
                          <FormControl>
                            <SelectTrigger>
                              <SelectValue placeholder="Select gender" />
                            </SelectTrigger>
                          </FormControl>
                          <SelectContent>
                            <SelectItem value="Male">Male</SelectItem>
                            <SelectItem value="Female">Female</SelectItem>
                            <SelectItem value="Other">Other</SelectItem>
                          </SelectContent>
                        </Select>
                        <FormMessage />
                      </FormItem>
                    )}
                  />
                  
                  <FormField
                    control={form.control}
                    name="birthdate"
                    render={({ field }) => (
                      <FormItem>
                        <FormLabel>Birthdate</FormLabel>
                        <FormControl>
                          <Input type="date" {...field} />
                        </FormControl>
                        <FormMessage />
                      </FormItem>
                    )}
                  />
                  
                  <FormField
                    control={form.control}
                    name="address"
                    render={({ field }) => (
                      <FormItem className="md:col-span-2">
                        <FormLabel>Address</FormLabel>
                        <FormControl>
                          <Textarea 
                            {...field} 
                            placeholder="Enter address"
                            rows={2}
                          />
                        </FormControl>
                        <FormMessage />
                      </FormItem>
                    )}
                  />
                </div>
              </div>

              {/* Fitness Information Section */}
              <div className="space-y-4 md:col-span-2">
                <h3 className="text-lg font-medium">Fitness Information</h3>
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <FormField
                    control={form.control}
                    name="fitness_level"
                    render={({ field }) => (
                      <FormItem>
                        <FormLabel>Fitness Level</FormLabel>
                        <Select 
                          onValueChange={field.onChange} 
                          defaultValue={field.value}
                        >
                          <FormControl>
                            <SelectTrigger>
                              <SelectValue placeholder="Select fitness level" />
                            </SelectTrigger>
                          </FormControl>
                          <SelectContent>
                            <SelectItem value="Beginner">Beginner</SelectItem>
                            <SelectItem value="Intermediate">Intermediate</SelectItem>
                            <SelectItem value="Advanced">Advanced</SelectItem>
                            <SelectItem value="Athlete">Athlete</SelectItem>
                          </SelectContent>
                        </Select>
                        <FormMessage />
                      </FormItem>
                    )}
                  />
                  
                  <FormField
                    control={form.control}
                    name="goal_type"
                    render={({ field }) => (
                      <FormItem>
                        <FormLabel>Goal Type</FormLabel>
                        <Select 
                          onValueChange={field.onChange} 
                          defaultValue={field.value}
                        >
                          <FormControl>
                            <SelectTrigger>
                              <SelectValue placeholder="Select goal type" />
                            </SelectTrigger>
                          </FormControl>
                          <SelectContent>
                            <SelectItem value="Weight_Loss">Weight Loss</SelectItem>
                            <SelectItem value="Muscle_Gain">Muscle Gain</SelectItem>
                            <SelectItem value="Endurance">Endurance</SelectItem>
                            <SelectItem value="Maintenance">Maintenance</SelectItem>
                            <SelectItem value="Flexibility">Flexibility</SelectItem>
                          </SelectContent>
                        </Select>
                        <FormMessage />
                      </FormItem>
                    )}
                  />
                  
                  <FormField
                    control={form.control}
                    name="height"
                    render={({ field }) => (
                      <FormItem>
                        <FormLabel>Height (cm)</FormLabel>
                        <FormControl>
                          <Input {...field} type="number" placeholder="175" />
                        </FormControl>
                        <FormMessage />
                      </FormItem>
                    )}
                  />
                  
                  <FormField
                    control={form.control}
                    name="current_weight"
                    render={({ field }) => (
                      <FormItem>
                        <FormLabel>Current Weight (kg)</FormLabel>
                        <FormControl>
                          <Input {...field} type="number" placeholder="70" />
                        </FormControl>
                        <FormMessage />
                      </FormItem>
                    )}
                  />
                  
                  <FormField
                    control={form.control}
                    name="calorie_goals"
                    render={({ field }) => (
                      <FormItem>
                        <FormLabel>Calorie Goals</FormLabel>
                        <FormControl>
                          <Input {...field} type="number" placeholder="2000" />
                        </FormControl>
                        <FormMessage />
                      </FormItem>
                    )}
                  />
                  
                  <FormField
                    control={form.control}
                    name="card_number"
                    render={({ field }) => (
                      <FormItem>
                        <FormLabel>Card Number</FormLabel>
                        <FormControl>
                          <Input {...field} placeholder="Enter RFID card number" />
                        </FormControl>
                        <FormMessage />
                      </FormItem>
                    )}
                  />
                  
                  <FormField
                    control={form.control}
                    name="allergies"
                    render={({ field }) => (
                      <FormItem className="md:col-span-2">
                        <FormLabel>Allergies</FormLabel>
                        <FormControl>
                          <Textarea 
                            {...field} 
                            placeholder="Enter any allergies or dietary restrictions"
                            rows={2}
                          />
                        </FormControl>
                        <FormMessage />
                      </FormItem>
                    )}
                  />
                </div>
              </div>
            </div>

            <DialogFooter>
              <Button type="button" variant="outline" onClick={() => setOpen(false)}>
                Cancel
              </Button>
              <Button type="submit" disabled={loading}>
                {loading && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
                Register User
              </Button>
            </DialogFooter>
          </form>
        </Form>
      </DialogContent>
    </Dialog>
  );
};

export default RegisterUserDialog;
// import React, { useState, useRef } from 'react';
// import {
//   Dialog,
//   DialogContent,
//   DialogDescription,
//   DialogFooter,
//   DialogHeader,
//   DialogTitle,
//   DialogTrigger,
// } from "@/components/ui/dialog";
// import {
//   Form,
//   FormControl,
//   FormDescription,
//   FormField,
//   FormItem,
//   FormLabel,
//   FormMessage,
// } from "@/components/ui/form";
// import {
//   Select,
//   SelectContent,
//   SelectItem,
//   SelectTrigger,
//   SelectValue,
// } from "@/components/ui/select";
// import { Input } from "@/components/ui/input";
// import { Button } from "@/components/ui/button";
// import { Textarea } from "@/components/ui/textarea";
// import { Plus, Loader2, Upload, X } from 'lucide-react';
// import { userInstance } from '@/network/axios';
// import { useToast } from "@/components/ui/use-toast";
// import { zodResolver } from '@hookform/resolvers/zod';
// import { useForm } from 'react-hook-form';
// import * as z from 'zod';
// import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";

// // Form validation schema
// const formSchema = z.object({
//   email: z.string().email({ message: "Please enter a valid email address" }),
//   password: z
//     .string()
//     .min(8, { message: "Password must be at least 8 characters long" })
//     .regex(
//       /^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/,
//       {
//         message: "Password must include uppercase, lowercase, number, and special character",
//       }
//     ),
//   user_name: z
//     .string()
//     .min(3, { message: "Username must be at least 3 characters long" })
//     .regex(/^[a-zA-Z0-9_]+$/, {
//       message: "Username can only contain letters, numbers, and underscores",
//     }),
//   full_name: z.string().optional(),
//   phone_number: z.string().optional(),
//   role: z.enum(["Admin", "Trainer", "Member"]),
//   address: z.string().optional(),
//   gender: z.enum(["Male", "Female", "Other"]).optional(),
//   birthdate: z.string().optional(),
//   height: z.string().optional(),
//   current_weight: z.string().optional(),
//   fitness_level: z.enum(["Beginner", "Intermediate", "Advanced", "Athlete"]).optional(),
//   goal_type: z.enum(["Weight_Loss", "Muscle_Gain", "Endurance", "Maintenance", "Flexibility"]).optional(),
//   allergies: z.string().optional(),
//   calorie_goals: z.string().optional(),
//   card_number: z.string().optional(),
//   // Image isn't included in the schema as it will be handled separately
// });

// const RegisterUserDialog = ({ onSuccess }) => {
//   const [open, setOpen] = useState(false);
//   const [loading, setLoading] = useState(false);
//   const [profileImage, setProfileImage] = useState(null);
//   const [previewUrl, setPreviewUrl] = useState('');
//   const fileInputRef = useRef(null);
//   const { toast } = useToast();

//   const form = useForm({
//     resolver: zodResolver(formSchema),
//     defaultValues: {
//       email: "",
//       password: "",
//       user_name: "",
//       full_name: "",
//       phone_number: "",
//       role: "Member",
//       address: "",
//       gender: undefined,
//       birthdate: "",
//       height: "",
//       current_weight: "",
//       fitness_level: undefined,
//       goal_type: undefined,
//       allergies: "",
//       calorie_goals: "",
//       card_number: "",
//     },
//   });

//   const handleImageChange = (e) => {
//     const file = e.target.files[0];
//     if (file) {
//       setProfileImage(file);
//       // Create preview URL
//       const reader = new FileReader();
//       reader.onloadend = () => {
//         setPreviewUrl(reader.result);
//       };
//       reader.readAsDataURL(file);
//     }
//   };

//   const clearImage = () => {
//     setProfileImage(null);
//     setPreviewUrl('');
//     if (fileInputRef.current) {
//       fileInputRef.current.value = '';
//     }
//   };

//   const handleSubmit = async (data) => {
//     setLoading(true);
//     try {
//       // Create FormData object to handle file upload
//       const formData = new FormData();
      
//       // Append all form data
//       Object.keys(data).forEach(key => {
//         formData.append(key, data[key]);
//       });
      
//       // Append image if selected
//       if (profileImage) {
//         formData.append('profile_image', profileImage);
//       }
      
//       // Make a multipart/form-data request
//       const response = await userInstance.post('/admin/users/register', formData, {
//         headers: {
//           'Content-Type': 'multipart/form-data'
//         }
//       });
      
//       toast({
//         title: "Success",
//         description: "User registered successfully",
//         variant: "default",
//       });
      
//       setOpen(false);
//       form.reset();
//       clearImage();
      
//       // Call success callback if provided (to refresh user list)
//       if (onSuccess) {
//         onSuccess();
//       }
//     } catch (error) {
//       console.error('Error registering user:', error);
      
//       // Handle different error cases
//       if (error.response?.data?.message) {
//         toast({
//           title: "Registration Failed",
//           description: error.response.data.message,
//           variant: "destructive",
//         });
//       } else {
//         toast({
//           title: "Registration Failed",
//           description: "An unexpected error occurred. Please try again.",
//           variant: "destructive",
//         });
//       }
//     } finally {
//       setLoading(false);
//     }
//   };

//   return (
//     <Dialog open={open} onOpenChange={setOpen}>
//       <DialogTrigger asChild>
//         <Button className="flex items-center gap-2">
//           <Plus className="h-4 w-4" />
//           Add New User
//         </Button>
//       </DialogTrigger>
//       <DialogContent className="max-w-3xl max-h-[90vh] overflow-y-auto">
//         <DialogHeader>
//           <DialogTitle>Register New User</DialogTitle>
//           <DialogDescription>
//             Create a new user account. Required fields are marked with an asterisk (*).
//           </DialogDescription>
//         </DialogHeader>

//         <Form {...form}>
//           <form onSubmit={form.handleSubmit(handleSubmit)} className="space-y-6">
//             <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
//               {/* Profile Image Section */}
//               <div className="space-y-4 md:col-span-2 flex flex-col items-center">
//                 <h3 className="text-lg font-medium self-start">Profile Image</h3>
//                 <div className="flex flex-col items-center gap-4">
//                   <Avatar className="h-24 w-24">
//                     <AvatarImage src={previewUrl} alt="Profile preview" />
//                     <AvatarFallback>
//                       {form.watch("full_name") 
//                         ? form.watch("full_name").charAt(0).toUpperCase() 
//                         : form.watch("user_name")
//                           ? form.watch("user_name").charAt(0).toUpperCase()
//                           : "U"}
//                     </AvatarFallback>
//                   </Avatar>
                  
//                   <div className="flex gap-2">
//                     <Button 
//                       type="button" 
//                       variant="outline" 
//                       size="sm"
//                       onClick={() => fileInputRef.current?.click()}
//                     >
//                       <Upload className="h-4 w-4 mr-2" />
//                       {previewUrl ? "Change Image" : "Upload Image"}
//                     </Button>
                    
//                     {previewUrl && (
//                       <Button 
//                         type="button" 
//                         variant="outline" 
//                         size="sm"
//                         onClick={clearImage}
//                       >
//                         <X className="h-4 w-4 mr-2" />
//                         Remove
//                       </Button>
//                     )}
                    
//                     <input
//                       type="file"
//                       ref={fileInputRef}
//                       onChange={handleImageChange}
//                       className="hidden"
//                       accept="image/*"
//                     />
//                   </div>
                  
//                   <FormDescription className="text-center">
//                     Upload a profile image (optional). If not provided, a default image will be used.
//                   </FormDescription>
//                 </div>
//               </div>
              
//               {/* Required Fields Section */}
//               <div className="space-y-4 md:col-span-2">
//                 <h3 className="text-lg font-medium">Account Information</h3>
//                 <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
//                   <FormField
//                     control={form.control}
//                     name="email"
//                     render={({ field }) => (
//                       <FormItem>
//                         <FormLabel>Email *</FormLabel>
//                         <FormControl>
//                           <Input {...field} placeholder="user@example.com" />
//                         </FormControl>
//                         <FormMessage />
//                       </FormItem>
//                     )}
//                   />
                  
//                   <FormField
//                     control={form.control}
//                     name="password"
//                     render={({ field }) => (
//                       <FormItem>
//                         <FormLabel>Password *</FormLabel>
//                         <FormControl>
//                           <Input 
//                             {...field} 
//                             type="password" 
//                             placeholder="●●●●●●●●" 
//                           />
//                         </FormControl>
//                         <FormDescription>
//                           Min 8 chars, with uppercase, lowercase, number & special char
//                         </FormDescription>
//                         <FormMessage />
//                       </FormItem>
//                     )}
//                   />
//                 </div>
//               </div>
              
//               <FormField
//                 control={form.control}
//                 name="user_name"
//                 render={({ field }) => (
//                   <FormItem>
//                     <FormLabel>Username *</FormLabel>
//                     <FormControl>
//                       <Input {...field} placeholder="username" />
//                     </FormControl>
//                     <FormMessage />
//                   </FormItem>
//                 )}
//               />
              
//               <FormField
//                 control={form.control}
//                 name="role"
//                 render={({ field }) => (
//                   <FormItem>
//                     <FormLabel>Role *</FormLabel>
//                     <Select 
//                       onValueChange={field.onChange} 
//                       defaultValue={field.value}
//                     >
//                       <FormControl>
//                         <SelectTrigger>
//                           <SelectValue placeholder="Select role" />
//                         </SelectTrigger>
//                       </FormControl>
//                       <SelectContent>
//                         <SelectItem value="Member">Member</SelectItem>
//                         <SelectItem value="Trainer">Trainer</SelectItem>
//                         <SelectItem value="Admin">Admin</SelectItem>
//                       </SelectContent>
//                     </Select>
//                     <FormMessage />
//                   </FormItem>
//                 )}
//               />
              
//               {/* Personal Information Section */}
//               <div className="space-y-4 md:col-span-2">
//                 <h3 className="text-lg font-medium">Personal Information</h3>
//                 <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
//                   <FormField
//                     control={form.control}
//                     name="full_name"
//                     render={({ field }) => (
//                       <FormItem>
//                         <FormLabel>Full Name</FormLabel>
//                         <FormControl>
//                           <Input {...field} placeholder="John Doe" />
//                         </FormControl>
//                         <FormMessage />
//                       </FormItem>
//                     )}
//                   />
                  
//                   <FormField
//                     control={form.control}
//                     name="phone_number"
//                     render={({ field }) => (
//                       <FormItem>
//                         <FormLabel>Phone Number</FormLabel>
//                         <FormControl>
//                           <Input {...field} placeholder="+1234567890" />
//                         </FormControl>
//                         <FormMessage />
//                       </FormItem>
//                     )}
//                   />
                  
//                   <FormField
//                     control={form.control}
//                     name="gender"
//                     render={({ field }) => (
//                       <FormItem>
//                         <FormLabel>Gender</FormLabel>
//                         <Select 
//                           onValueChange={field.onChange} 
//                           defaultValue={field.value}
//                         >
//                           <FormControl>
//                             <SelectTrigger>
//                               <SelectValue placeholder="Select gender" />
//                             </SelectTrigger>
//                           </FormControl>
//                           <SelectContent>
//                             <SelectItem value="Male">Male</SelectItem>
//                             <SelectItem value="Female">Female</SelectItem>
//                             <SelectItem value="Other">Other</SelectItem>
//                           </SelectContent>
//                         </Select>
//                         <FormMessage />
//                       </FormItem>
//                     )}
//                   />
                  
//                   <FormField
//                     control={form.control}
//                     name="birthdate"
//                     render={({ field }) => (
//                       <FormItem>
//                         <FormLabel>Birthdate</FormLabel>
//                         <FormControl>
//                           <Input type="date" {...field} />
//                         </FormControl>
//                         <FormMessage />
//                       </FormItem>
//                     )}
//                   />
                  
//                   <FormField
//                     control={form.control}
//                     name="address"
//                     render={({ field }) => (
//                       <FormItem className="md:col-span-2">
//                         <FormLabel>Address</FormLabel>
//                         <FormControl>
//                           <Textarea 
//                             {...field} 
//                             placeholder="Enter address"
//                             rows={2}
//                           />
//                         </FormControl>
//                         <FormMessage />
//                       </FormItem>
//                     )}
//                   />
//                 </div>
//               </div>

//               {/* Fitness Information Section */}
//               <div className="space-y-4 md:col-span-2">
//                 <h3 className="text-lg font-medium">Fitness Information</h3>
//                 <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
//                   <FormField
//                     control={form.control}
//                     name="fitness_level"
//                     render={({ field }) => (
//                       <FormItem>
//                         <FormLabel>Fitness Level</FormLabel>
//                         <Select 
//                           onValueChange={field.onChange} 
//                           defaultValue={field.value}
//                         >
//                           <FormControl>
//                             <SelectTrigger>
//                               <SelectValue placeholder="Select fitness level" />
//                             </SelectTrigger>
//                           </FormControl>
//                           <SelectContent>
//                             <SelectItem value="Beginner">Beginner</SelectItem>
//                             <SelectItem value="Intermediate">Intermediate</SelectItem>
//                             <SelectItem value="Advanced">Advanced</SelectItem>
//                             <SelectItem value="Athlete">Athlete</SelectItem>
//                           </SelectContent>
//                         </Select>
//                         <FormMessage />
//                       </FormItem>
//                     )}
//                   />
                  
//                   <FormField
//                     control={form.control}
//                     name="goal_type"
//                     render={({ field }) => (
//                       <FormItem>
//                         <FormLabel>Goal Type</FormLabel>
//                         <Select 
//                           onValueChange={field.onChange} 
//                           defaultValue={field.value}
//                         >
//                           <FormControl>
//                             <SelectTrigger>
//                               <SelectValue placeholder="Select goal type" />
//                             </SelectTrigger>
//                           </FormControl>
//                           <SelectContent>
//                             <SelectItem value="Weight_Loss">Weight Loss</SelectItem>
//                             <SelectItem value="Muscle_Gain">Muscle Gain</SelectItem>
//                             <SelectItem value="Endurance">Endurance</SelectItem>
//                             <SelectItem value="Maintenance">Maintenance</SelectItem>
//                             <SelectItem value="Flexibility">Flexibility</SelectItem>
//                           </SelectContent>
//                         </Select>
//                         <FormMessage />
//                       </FormItem>
//                     )}
//                   />
                  
//                   <FormField
//                     control={form.control}
//                     name="height"
//                     render={({ field }) => (
//                       <FormItem>
//                         <FormLabel>Height (cm)</FormLabel>
//                         <FormControl>
//                           <Input {...field} type="number" placeholder="175" />
//                         </FormControl>
//                         <FormMessage />
//                       </FormItem>
//                     )}
//                   />
                  
//                   <FormField
//                     control={form.control}
//                     name="current_weight"
//                     render={({ field }) => (
//                       <FormItem>
//                         <FormLabel>Current Weight (kg)</FormLabel>
//                         <FormControl>
//                           <Input {...field} type="number" placeholder="70" />
//                         </FormControl>
//                         <FormMessage />
//                       </FormItem>
//                     )}
//                   />
                  
//                   <FormField
//                     control={form.control}
//                     name="calorie_goals"
//                     render={({ field }) => (
//                       <FormItem>
//                         <FormLabel>Calorie Goals</FormLabel>
//                         <FormControl>
//                           <Input {...field} type="number" placeholder="2000" />
//                         </FormControl>
//                         <FormMessage />
//                       </FormItem>
//                     )}
//                   />
                  
//                   <FormField
//                     control={form.control}
//                     name="card_number"
//                     render={({ field }) => (
//                       <FormItem>
//                         <FormLabel>Card Number</FormLabel>
//                         <FormControl>
//                           <Input {...field} placeholder="Enter RFID card number" />
//                         </FormControl>
//                         <FormMessage />
//                       </FormItem>
//                     )}
//                   />
                  
//                   <FormField
//                     control={form.control}
//                     name="allergies"
//                     render={({ field }) => (
//                       <FormItem className="md:col-span-2">
//                         <FormLabel>Allergies</FormLabel>
//                         <FormControl>
//                           <Textarea 
//                             {...field} 
//                             placeholder="Enter any allergies or dietary restrictions"
//                             rows={2}
//                           />
//                         </FormControl>
//                         <FormMessage />
//                       </FormItem>
//                     )}
//                   />
//                 </div>
//               </div>
//             </div>

//             <DialogFooter>
//               <Button type="button" variant="outline" onClick={() => setOpen(false)}>
//                 Cancel
//               </Button>
//               <Button type="submit" disabled={loading}>
//                 {loading && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
//                 Register User
//               </Button>
//             </DialogFooter>
//           </form>
//         </Form>
//       </DialogContent>
//     </Dialog>
//   );
// };

// export default RegisterUserDialog;