// import React, { useState } from 'react';
// import { useNavigate } from 'react-router-dom';
// import axios from 'axios';
// import { userInstance } from '@/network/axios'; // Import axios instance
// import { Input } from '@/components/ui/input';
// import { Button } from '@/components/ui/button';
// import { Card, CardContent, CardHeader, CardTitle, CardDescription } from '@/components/ui/card';

// const LoginPage = () => {
//   const navigate = useNavigate(); // Hook to navigate to different routes
//   const [email, setEmail] = useState('');
//   const [password, setPassword] = useState('');
//   const [error, setError] = useState('');
//   const [loading, setLoading] = useState(false);

//   const handleLogin = async (e: React.FormEvent) => {
//     e.preventDefault();

//     if (!email || !password) {
//       setError('Please provide both email and password');
//       return;
//     }

//     setLoading(true);
//     setError('');

//     try {
//       // Make the POST request to login the user
//       // const response = await axios.post('http://localhost:8000/api/auth/login', {
//       //   email,
//       //   password,
//       // });
//       const response = await userInstance.post('/auth/login', {
//         email,
//         password,
//       })

//       // Check for success
//       if (response.status === 200) {
//         // Store the JWT token in localStorage (or other storage method)
//         localStorage.setItem('token', response.data.token);

//         // Redirect the user to the dashboard
//         navigate('/dashboard'); // Navigate to '/dashboard' route after successful login
//       }
//     } catch (error) {
//       setError('Login failed. Please check your credentials and try again.');
//     } finally {
//       setLoading(false);
//     }
//   };

//   return (
//     <div className="flex justify-center items-center min-h-screen bg-gray-100">
//       <Card className="w-full max-w-md">
//         <CardHeader>
//           <CardTitle>Login</CardTitle>
//           <CardDescription>Please enter your email and password to log in</CardDescription>
//         </CardHeader>
//         <CardContent>
//           <form onSubmit={handleLogin}>
//             <div className="space-y-4">
//               {/* Email Input */}
//               <div>
//                 <label htmlFor="email" className="block text-sm font-medium text-gray-700">Email</label>
//                 <Input
//                   type="email"
//                   id="email"
//                   placeholder="Enter your email"
//                   value={email}
//                   onChange={(e) => setEmail(e.target.value)}
//                   required
//                 />
//               </div>

//               {/* Password Input */}
//               <div>
//                 <label htmlFor="password" className="block text-sm font-medium text-gray-700">Password</label>
//                 <Input
//                   type="password"
//                   id="password"
//                   placeholder="Enter your password"
//                   value={password}
//                   onChange={(e) => setPassword(e.target.value)}
//                   required
//                 />
//               </div>

//               {/* Error Message */}
//               {error && <p className="text-red-500 text-sm">{error}</p>}

//               {/* Submit Button */}
//               <div>
//                 <Button type="submit"  className="w-full" disabled={loading}>
//                   {loading ? 'Logging in...' : 'Log in'}
//                 </Button>
//               </div>
//             </div>
//           </form>
//         </CardContent>
//       </Card>
//     </div>
//   );
// };

// export default LoginPage;


import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { userInstance } from '@/network/axios'; // Import axios instance
import { Input } from '@/components/ui/input';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from '@/components/ui/card';

const LoginPage = () => {
  const navigate = useNavigate(); // Hook to navigate to different routes
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);

  const handleLogin = async (e) => {
    e.preventDefault();

    if (!email || !password) {
      setError('Please provide both email and password');
      return;
    }

    setLoading(true);
    setError('');

    try {
      const response = await userInstance.post('/auth/login', {
        email,
        password,
      });

      // Check for success
      if (response.status === 200) {
        // Store the JWT token in localStorage (or other storage method)
        localStorage.setItem('token', response.data.token);

        // Redirect the user to the dashboard
        navigate('/dashboard', { replace: true }); // Replace history to prevent going back to login
      }
    } catch (error) {
      setError('Login failed. Please check your credentials and try again.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="flex justify-center items-center min-h-screen bg-gray-100">
      <Card className="w-full max-w-md">
        <CardHeader>
          <CardTitle>Login to Admin Dashboard</CardTitle>
          <CardDescription>Please enter your email and password to log in</CardDescription>
        </CardHeader>
        <CardContent>
          <form onSubmit={handleLogin}>
            <div className="space-y-4">
              {/* Email Input */}
              <div>
                <label htmlFor="email" className="block text-sm font-medium text-gray-700">Email</label>
                <Input
                  type="email"
                  id="email"
                  placeholder="Enter your email"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  required
                />
              </div>

              {/* Password Input */}
              <div>
                <label htmlFor="password" className="block text-sm font-medium text-gray-700">Password</label>
                <Input
                  type="password"
                  id="password"
                  placeholder="Enter your password"
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  required
                />
              </div>

              {/* Error Message */}
              {error && <p className="text-red-500 text-sm">{error}</p>}

              {/* Submit Button */}
              <div>
                <Button type="submit" className="w-full" disabled={loading}>
                  {loading ? 'Logging in...' : 'Log in'}
                </Button>
              </div>
            </div>
          </form>
        </CardContent>
      </Card>
    </div>
  );
};

export default LoginPage;