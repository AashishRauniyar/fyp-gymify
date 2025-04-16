import React, { useState } from 'react';
import { 
  LayoutDashboard,
  Users,
  CreditCard,
  Dumbbell,
  ChevronLeft,
  ChevronRight,
  Calendar,
  Settings,
  CurrencyIcon
} from 'lucide-react';
import { Link, useLocation } from 'react-router-dom';

const Sidebar = () => {
  const [collapsed, setCollapsed] = useState(false);
  const location = useLocation();

  // Navigation items
  const navItems = [
    {
      title: 'Dashboard',
      href: '/dashboard',
      icon: LayoutDashboard,
    },
    {
      title: 'Users',
      href: '/users',
      icon: Users,
    },
    {
      title: 'User Analytics',
      href: '/userAnalytics',
      icon: Users,
    },
    {
      title: 'Memberships',
      href: '/memberships',
      icon: Calendar,
    },
    {
      title: 'Membership Plans',
      href: '/MembershipPlans',
      icon: Calendar,
    },
    {
      title: 'Payment',
      href: '/Revenue',
      icon: CreditCard,
    },
    // {
    //   title: 'Exercises',
    //   href: '/exercises',
    //   icon: Dumbbell,
    // },
    // {
    //   title: 'Workouts',
    //   href: '/workouts',
    //   icon: Dumbbell,
    // },
    // {
    //   title: 'Settings',
    //   href: '/settings',
    //   icon: Settings,
    // },
  ];

  const cn = (...classes) => {
    return classes.filter(Boolean).join(' ');
  };

  return (
    <aside
      className={cn(
        "h-screen bg-gray-900 text-gray-100 flex flex-col border-r border-gray-800 transition-all duration-300 ease-in-out relative",
        collapsed ? "w-20" : "w-64"
      )}
    >
      <div className="flex items-center justify-between h-16 px-4 border-b border-gray-800/20">
        {!collapsed && (
          <Link to="/" className="flex items-center gap-2">
            <div className="w-8 h-8 rounded-full bg-blue-600 flex items-center justify-center">
              <Dumbbell className="h-4 w-4" />
            </div>
            <span className="font-bold text-xl transition-all duration-300 text-blue-500">Gymify</span>
          </Link>
        )}
        <button
          onClick={() => setCollapsed(!collapsed)}
          className={cn(
            "rounded-full h-8 w-8 text-gray-400 hover:text-white hover:bg-gray-800/50 transition-all duration-300 flex items-center justify-center",
            collapsed && "mx-auto"
          )}
        >
          {collapsed ? 
            <ChevronRight className="h-5 w-5" /> : 
            <ChevronLeft className="h-5 w-5" />
          }
        </button>
      </div>

      <div className="flex-1 py-4 px-3 space-y-1 overflow-y-auto">
        {navItems.map((item) => (
          <Link
            key={item.href}
            to={item.href}
            className={cn(
              "flex items-center py-2 px-3 rounded-md text-gray-400 hover:text-white hover:bg-gray-800/50 transition-all duration-200 cursor-pointer",
              location.pathname === item.href && "bg-blue-900/30 text-blue-400 font-medium",
              collapsed && "justify-center px-0"
            )}
          >
            <item.icon className={cn("h-5 w-5", collapsed && "mx-auto")} />
            {!collapsed && <span className="ml-3">{item.title}</span>}
          </Link>
        ))}
      </div>
      
      
    </aside>
  );
};

export default Sidebar;