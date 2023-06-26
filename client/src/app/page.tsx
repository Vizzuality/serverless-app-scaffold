import Hydrate from '@/lib/react-query/hydrate';

import Datasets from '@/containers/home/datasets';
import Map from '@/containers/home/map';

import { prefetchQueries } from './prefetch';

export default async function Home() {
  const dehydratedState = await prefetchQueries();

  return (
    <Hydrate state={dehydratedState}>
      <main className="flex min-h-screen flex-col">
        <div className="h-screen w-screen">
          <Map />
          <Datasets />
        </div>
      </main>
    </Hydrate>
  );
}
