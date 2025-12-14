import { Route as rootRoute } from './routes/__root';
import { Route as IndexRoute } from './routes/index';
import { Route as CertificateRoute } from './routes/certificate';

const IndexRouteWithChildren = IndexRoute.update({
  path: '/',
  getParentRoute: () => rootRoute,
} as never);

const CertificateRouteWithChildren = CertificateRoute.update({
  path: '/certificate',
  getParentRoute: () => rootRoute,
} as never);

export const routeTree = rootRoute.addChildren([
  IndexRouteWithChildren,
  CertificateRouteWithChildren,
]);
