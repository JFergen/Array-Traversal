	.data

	.type	n, %object
	.type	A, %object
	.size	A, 6
	.size	n, 1
A:	.xword	42, 51, 3, 29, 65, 17
n:	.xword	6

	.text
	.global main
	.arch armv8-a+fp+simd
	.type main, %function

main:	// A in X0, n in X1, i in X3, sum in X10, largest value in X11, smallest value in X12
		ADRP X0, A	// Get address of array A
		ADD X0, X0, :lo12:A
		ADRP X1, n	// Get address of variable n
		ADD X1, X1, :lo12:n

		LDUR X1, [X1, #0]	// Load n into X1
		SUB X10, X10, X10	// Initalize sum to zero
		LDUR X11, [X0, #0]	// A[0] into X11 (largest num)
		LDUR X12, [X0, #0]	// A[0] into X12 (smallest num)

		SUB X2, X2, X2	// Initalize i in X2 to zero
loop:
		LDUR X3, [X0, #0]	// A[i] into X3

		ADD X10, X10, X3	// sum = sum + A[i]

		SUBS X4, X3, X11	// X4 = A[i] - A[0]
		B.LT else1	// If A[i] > A[0], swap in X11
		LDUR X11, [X0, #0]	// Largest num = A[i]
else1:
		SUBS X4, X3, X12	// X4 = A[i] - A[0]

		B.GT else2	// If A[i] < A[0], swap in X12
		LDUR X12, [X0, #0]	// Smallest num = A[i]
else2:
		ADD X2, X2, #1	// i = i + 1

		ADD X0, X0, #8	// Next array element
		SUB X4, X1, X2	// Check if i < n
		CBNZ X4, loop	// if i < n, continue the loop

		SUB X13, X11, X12 // After loop is finished. Find difference between max and min.
exit:
