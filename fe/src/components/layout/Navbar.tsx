
// import React from 'react';
// import { Bell, Search, User } from 'lucide-react';
// import { Input } from '@/components/ui/input';
// import { Button } from '@/components/ui/button';
// import {
//   DropdownMenu,
//   DropdownMenuContent,
//   DropdownMenuItem,
//   DropdownMenuLabel,
//   DropdownMenuSeparator,
//   DropdownMenuTrigger,
// } from '@/components/ui/dropdown-menu';
// import { Avatar, AvatarImage, AvatarFallback } from '@/components/ui/avatar';

// const Navbar = () => {
//   return (
//     <nav className="h-16 px-4 border-b border-border/40 bg-white/50 backdrop-blur-md flex items-center justify-between transition-all duration-200">
//       <div className="flex items-center gap-4 w-1/3">
        
//       </div>

//       <div className="flex items-center gap-3">
//         <Button
//           variant="ghost"
//           size="icon"
//           className="rounded-full text-muted-foreground hover:text-foreground transition-all duration-200"
//         >
//           <Bell className="h-5 w-5" />
//         </Button>

//         <DropdownMenu>
//           <DropdownMenuTrigger asChild>
//             <Button
//               variant="ghost"
//               className="relative h-9 w-9 rounded-full transition-all duration-200"
//             >
//               <Avatar className="h-9 w-9 transition-all duration-200 hover:opacity-80">
//                 <AvatarImage src="https://i.pravatar.cc/150?img=1" alt="Admin" />
//                 <AvatarFallback>AD</AvatarFallback>
//               </Avatar>
//             </Button>
//           </DropdownMenuTrigger>
//           <DropdownMenuContent className="w-56" align="end" forceMount>
//             <DropdownMenuLabel className="font-normal">
//               <div className="flex flex-col space-y-1">
//                 <p className="text-sm font-medium leading-none">Admin</p>
//                 <p className="text-xs leading-none text-muted-foreground">admin@example.com</p>
//               </div>
//             </DropdownMenuLabel>
//             <DropdownMenuSeparator />
//             <DropdownMenuItem>
//               <User className="mr-2 h-4 w-4" />
//               <span>Profile</span>
//             </DropdownMenuItem>
//             <DropdownMenuItem>Settings</DropdownMenuItem>
//             <DropdownMenuSeparator />
//             <DropdownMenuItem>Log out</DropdownMenuItem>
//           </DropdownMenuContent>
//         </DropdownMenu>
//       </div>
//     </nav>
//   );
// };

// export default Navbar;



import React, { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { Bell, User, LogOut, Lock } from 'lucide-react';
import { Button } from '@/components/ui/button';
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu';
import { Avatar, AvatarImage, AvatarFallback } from '@/components/ui/avatar';
import { userInstance } from '@/network/axios'; // Import axios instance

const Navbar = () => {
  const navigate = useNavigate();
  const [userData, setUserData] = useState({
    full_name: 'Admin',
    email: 'admin@example.com',
    profile_image: null
  });

  // Fetch user profile when component mounts
  useEffect(() => {
    const fetchUserProfile = async () => {
      try {
        const token = localStorage.getItem('token');
        if (token) {
          const response = await userInstance.get('/profile');
          if (response.data.status === 'success') {
            setUserData(response.data.data);
          }
        }
      } catch (error) {
        console.error('Failed to fetch user profile:', error);
      }
    };

    fetchUserProfile();
  }, []);

  // Handle logout
  const handleLogout = () => {
    // Remove token from localStorage
    localStorage.removeItem('token');
    
    // Redirect to login page
    navigate('/');
  };

  // Handle profile navigation
  const handleProfileClick = () => {
    navigate('/profile');
  };

  return (
    <nav className="h-16 px-4 border-b border-border/40 bg-white/50 backdrop-blur-md flex items-center justify-between transition-all duration-200">
      <div className="flex items-center gap-4 w-1/3">
      </div>

      <div className="flex items-center gap-3">
        <Button
          variant="ghost"
          size="icon"
          className="rounded-full text-muted-foreground hover:text-foreground transition-all duration-200"
        >
          <Bell className="h-5 w-5" />
        </Button>

        <DropdownMenu>
          <DropdownMenuTrigger asChild>
            <Button
              variant="ghost"
              className="relative h-9 w-9 rounded-full transition-all duration-200"
            >
              <Avatar className="h-9 w-9 transition-all duration-200 hover:opacity-80">
                {userData.profile_image ? (
                  <AvatarImage src={userData.profile_image} alt={userData.full_name} />
                ) : (
                  <AvatarFallback>{userData.full_name?.substring(0, 2).toUpperCase() || 'AD'}</AvatarFallback>
                )}
              </Avatar>
            </Button>
          </DropdownMenuTrigger>
          <DropdownMenuContent className="w-56" align="end" forceMount>
            <DropdownMenuLabel className="font-normal">
              <div className="flex flex-col space-y-1">
                <p className="text-sm font-medium leading-none">{userData.full_name || 'Admin'}</p>
                <p className="text-xs leading-none text-muted-foreground">{userData.email || 'admin@example.com'}</p>
              </div>
            </DropdownMenuLabel>
            <DropdownMenuSeparator />
            <DropdownMenuItem onClick={handleProfileClick}>
              <User className="mr-2 h-4 w-4" />
              <span>Profile</span>
            </DropdownMenuItem>
            <DropdownMenuItem onClick={() => navigate('/profile?tab=security')}>
              <Lock className="mr-2 h-4 w-4" />
              <span>Change Password</span>
            </DropdownMenuItem>
            <DropdownMenuSeparator />
            <DropdownMenuItem onClick={handleLogout}>
              <LogOut className="mr-2 h-4 w-4" />
              <span>Log out</span>
            </DropdownMenuItem>
          </DropdownMenuContent>
        </DropdownMenu>
      </div>
    </nav>
  );
};

export default Navbar;