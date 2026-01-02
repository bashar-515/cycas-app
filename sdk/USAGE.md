<!-- Start SDK Example Usage [usage] -->
```typescript
import { Cycas } from "cycas";

const cycas = new Cycas();

async function run() {
  const result = await cycas.categories.create({
    name: "<value>",
  });

  console.log(result);
}

run();

```
<!-- End SDK Example Usage [usage] -->