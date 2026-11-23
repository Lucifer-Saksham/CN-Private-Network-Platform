# Load-balancing evidence

```bash
bash ../../scripts/test-load-balancing.sh
```

or six curls to `http://10.3.3.178:8080/api/status`.

The screenshot must show both `A` and `B` appearing. Historical live sequence was B A B A B A; a different starting peer is still round-robin.
