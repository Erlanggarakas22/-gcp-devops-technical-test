# Troubleshooting Scenario

## Scenario

An application running on Compute Engine frequently becomes unavailable
because of full memory utilization. Logs indicate a memory leak that cannot
be fixed immediately.

## Quick-Win Actions

First, I would configure memory-utilization and OOM alerts so the operations
team receives warnings before the VM becomes unavailable. I would configure
the application process with automatic restart through systemd and introduce
a temporary controlled restart schedule before memory is exhausted. I would
temporarily increase VM memory and configure swap as a safety buffer, while
making it clear that these actions only delay the failure. To improve
availability, I would run multiple instances behind a load balancer and use
a Managed Instance Group with health checks and autohealing. I would also
review traffic patterns and temporarily reduce concurrency or apply rate
limits if high request volume accelerates memory growth.

## Long-Term Solutions

The development team should profile heap allocations and identify objects,
connections, threads, or caches that are not being released. Load tests,
soak tests, and memory-regression tests should be added to CI/CD so the issue
can be reproduced before production deployment. The application should
implement proper connection lifecycle management, bounded caches, resource
limits, and graceful shutdown behavior. A highly available runtime should
include health checks, horizontal scaling, rolling deployments, and
autohealing. Dashboards should track process RSS, heap utilization,
garbage-collection activity, OOM events, latency, error rate, and restart
count. Finally, an operational runbook and capacity baseline should document
safe traffic, memory, and concurrency limits.
