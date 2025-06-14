'use client';

import { useEffect, useState } from 'react';

export default function HomePage() {
  const [message, setMessage] = useState('');

  useEffect(() => {
    fetch('/api/hello')
      .then((res) => res.json())
      .then((data) => setMessage(data.message))
      .catch(() => setMessage('Failed to fetch'));
  }, []);

  return (
    <main className="p-6">
      <h1 className="text-2xl font-bold">Welcome to TradeMinutes</h1>
      <p className="mt-4">API Response: {message}</p>
    </main>
  );
}
