import { createFileRoute, useNavigate } from '@tanstack/react-router';
import { useEffect } from 'react';
import { CodeEntry } from '../components/CodeEntry';
import { getSavedMemberCode } from '../hooks/useMember';

export const Route = createFileRoute('/')({
  component: IndexPage,
});

function IndexPage() {
  const navigate = useNavigate();

  useEffect(() => {
    const savedCode = getSavedMemberCode();
    if (savedCode) {
      navigate({ to: '/certificate' });
    }
  }, [navigate]);

  return <CodeEntry />;
}
