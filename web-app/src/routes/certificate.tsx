import { createFileRoute } from '@tanstack/react-router';
import { Certificate } from '../components/Certificate';

export const Route = createFileRoute('/certificate')({
  component: Certificate,
});
