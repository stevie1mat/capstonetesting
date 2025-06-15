'use client';

import Navbar from '@/components/Navbar';
import Footer from '@/components/Footer';
import CategoryTabsWithBreadcrumb from '@/components/CategoriesWithBreadcrumbs';
import TradeMinutesActionSteps from '@/components/ActionSteps';
import dynamic from 'next/dynamic';

const MapUsers = dynamic(() => import('@/components/UsersNearby'), { ssr: false });
import ServiceFilters from '@/components/ServiceFilters';
import UsersNearbyBanner from '@/components/UsersNearbyBanner';

export default function UsersNearby() {
  return (
    <main className="bg-white min-h-screen text-black">
      <Navbar />
      <br />
      <CategoryTabsWithBreadcrumb />
      <UsersNearbyBanner />

      <div className="max-w-7xl mx-auto px-0 py-8">
        <br />
        <ServiceFilters />
        <br />
        <MapUsers />

      </div>
      <TradeMinutesActionSteps />
      <Footer />
    </main>
  );
}
