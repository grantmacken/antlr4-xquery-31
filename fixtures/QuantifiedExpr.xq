

(
 every $part in /parts/part satisfies $part/@discounted,
 some $emp in /emps/employee satisfies($emp/bonus > 0.25 * $emp/salary),
 every $r in $R satisfies $r instance of node()
)



