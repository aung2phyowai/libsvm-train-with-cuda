svm-train with CUDA

  1. Base on libsvm-3.18. Two bottleneck functions are rewritten with CUDA support. Modify the original implement as less as possible, as you can see:
```
                CUDA_k_function(model->SV, l, model->param, x, kvalue);
/*
                // Verify the result
                float val;
                if( (float)kvalue[i]!=(val=Kernel::k_function(x,model->SV[i],model->param)) )
                        printf("CUDA_k_function result not match %d, %f != %f\n", i, kvalue[i], val);
*/
/*
                // original implement
#pragma omp parallel for private(i)
                for(i=0;i<l;i++)
                        kvalue[i] = Kernel::k_function(x,model->SV[i],model->param);
*/
```
  1. Tested in Linux ONLY.
  1. svm-train **ONLY**, svm-predict is not supported yet.
  1. svm\_type support C-SVC(default value of libsvm) **ONLY**.
  1. probability\_estimates (-b 1) is SUPPORTED.
  1. kernel\_type tested with "radial basis function"(default value of libsvm) **ONLY**. The other kernel\_type **SHOULD** be OK, but not tested.
  1. **-h 0 is a MUST.**

So you should run svm-train like this:<br>
<b>svm-train -h 0 -s 0 -t 2 .....</b><br>
or<br>
<b>svm-train -h 0 -s 0 -t 2 -b 1.....</b><br>