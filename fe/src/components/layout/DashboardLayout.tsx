
import React from 'react';
import Sidebar from './Sidebar';
import Navbar from './Navbar';

interface DashboardLayoutProps {
  children: React.ReactNode;
}

const DashboardLayout: React.FC<DashboardLayoutProps> = ({ children }) => {
  return (
    <div className="flex h-screen bg-background">
      <Sidebar />
      <div className="flex flex-col flex-grow overflow-hidden">
        <Navbar />
        <main className="flex-grow overflow-auto">
          <div className="container h-full py-6 px-6 max-w-7xl animate-fade-in">
            {children}
          </div>
        </main>
      </div>
    </div>
  );
};

export default DashboardLayout;