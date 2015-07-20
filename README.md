**Deep Recurrent Neural Network for Audio Source Separation**

A Matlab implementation of DRNN for monaural audio source separation based on the joint optimization of masking functions and discriminative training criteria of Huang et al. [1].

With this framework one can also set several kinds of inicializations for DRNN, such as: "Xavier" [2], "He" [3] and "IRNN" [4].

**Getting Started**

1. training: run_train.m (run_train.sh is only used to run the scrip into the server)
 
2. testing: run_test.m

To try the codes on your data: put your data into a waves/ folder. The waves/ folder should be into the same root folder as DRNN4ASS/.

Inside DRNN4ASS/ the directories DRNN4ASS/models and DRNN4ASS/resultWaves should also be created to store the models and the output .wav files.

Look at the unit test parameters below codes/ or the parameters used in run_train.m and run_test.m. 

**Dependencies**

1. The package is modified based on deeplearningsourceseparation (Reference: https://sites.google.com/site/deeplearningsourceseparation/) that at its time is based on rnn-speech-denoising (Reference: https://github.com/amaas/rnn-speech-denoising).

2. Mark Schmidt's minFunc package for convex optimization (Reference: http://www.di.ens.fr/~mschmidt/Software/minFunc.html).

3. Mark Hasegawa-Johnson's HTK write and read functions that are used to handle the features files (Reference: http://www.isle.illinois.edu/sst/software/).

4. HTK for computing features (Reference: http://htk.eng.cam.ac.uk/).

5. Signal processing functions from Labrosa (Reference: http://labrosa.ee.columbia.edu/).

6. BSS Eval toolbox Version 3.0 for evaluation (Reference: http://bass-db.gforge.inria.fr/bss_eval/).

**References**

[1] Po-Sen Huang, Minje Kim, Mark Hasegawa-Johnson, Paris Smaragdis (2015). "Joint Optimization of Masks and Deep Recurrent Neural Networks for Monaural Source Separation" to appear in IEEE/ACM Transactions on Audio, Speech, and Language Processing.

[2] Glorot, X., & Bengio, Y. (2010). Understanding the difficulty of training deep feedforward neural networks. In International conference on artificial intelligence and statistics (pp. 249-256).

[3] He, K., Zhang, X., Ren, S., & Sun, J. (2015). Delving deep into rectifiers: Surpassing human-level performance on imagenet classification. arXiv preprint arXiv:1502.01852.

[4] Le, Q. V., Jaitly, N., & Hinton, G. E. (2015). A Simple Way to Initialize Recurrent Networks of Rectified Linear Units. arXiv preprint arXiv:1504.00941.

** Author of the modification**
Jordi Pons (idrojsnop@gmail.com)
