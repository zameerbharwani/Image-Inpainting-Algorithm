%% Image Inpainting Using Nonlocal Texture Matching and Nonlinear Filtering
% by Thomas Akdeniz, Zameer Bharwani, and Kristoff Malejczuk
%
%% Introduction
% 
% Image inpainting is a technique used to reconstruct images. It may be
% used for applications such as image restoration, object removal or error
% concealment. The success of image inpainting may be gauged from
% _consistency of intensity_ and _consistency of texture._ Two main
% categories of inpainting algorithms exist today: diffusion-based
% inpainting - which maximizes consistency of intensity - and patch-based
% inpainting - which maximizes consistency of texture. To optimize for both
% intensity and texture consistency in the inpainted image, variations on
% these algorithms have been proposed using a combination of the two
% aforementioned methods, neural networks, and nonlocal means filtering.
% Despite advancements in the field, inpainted images often appear visibly
% altered and there remains room for advancement towards obtaining even
% higher quality results.
% 
%% Proposed Solution
% 
% Ding et al. proposed a novel inpainting method in "Image Inpainting Using
% Nonlocal Texture Matching and Nonlinear Filtering," published in 2019 in
% the IEEE Transactions on Image Processing. This inpainting method is
% based on a nonlocal texture similarity (NLTS) measure and pixel-wise
% intensity smoothing. The image is divided into two regions: the source
% region, $\Omega ^C$, and the missing region, $\Omega$. The missing region
% is the part of the image that will be inpainted. The source region is the
% remainder of the image. A target patch, $\psi _p$, in the missing region
% will be selected and matched with candidate patches, $\psi _q$, from the
% source region. An integer number, $\lambda$, candidate patches will be
% filtered and used to inpaint the target patch. A new target patch is then
% located and this procedure is repeated until the missing region has been
% entirely inpainted.
%
% The inpainting procedure may be divided into three main parts:
% 
% # Target Patch Selection
% # Candidate Patch Selection
% # Inpainting
%
% * Target Patch Selection
% 
% The target patch is an _m x m_ matrix whose centre pixel _p_ will lie on
% the outer border, $\delta \Phi$, of the missing region. Target patch
% selection is performed based on a priority function, _P($\psi _p$)_.
% _P($\psi _p$)_ is the product of a confidence term, _C($\psi _p$)_, and a
% data term, _D($\psi _p$)_. The confidence term is the ratio of known
% pixels to unknown pixels in the target region. The data term is the
% intensity-normalized dot product between the isophote vector and the
% normal vector at the centre pixel _p_. _P($\psi _p$)_ is calculated for
% every pixel along the outer border of the missing region. The patch $\psi
% _p$ which maximizes the priority function is selected as the target
% patch.
% 
% <<patch_eq copy.png>>
% 
% * Candidate Patch Selection
%
% Once the target patch is selected, a NLTS measure is used to determine
% the optimal candidate patches from the source region. Candidate patches
% are also of size _m x m_. The intensities $I_p$ of the known regions of
% the target patch are compared element-wise against the intensities $I_q$
% of potential candidate patches. A Gaussian weight $G$ is used to
% prioritize closer matching between the centres $(x_c, y_c)$ of the
% patches relative to the outer edges of the patches. _h_ and $\sigma$ were
% selected empirically by Ding et al. to be 34 and in the range of [1.5,
% 2.5], respectively. The $\lambda$ images with highest NLTS
% scores are selected to be the candidate patches.
% 
% <<cand_eq copy.png>>
% 
% * Inpainting
% 
% Once the candidate patches are selected, an $\alpha$-trimmed mean filter
% is applied to the set $S_0$ of candidate patches. The smoothed result is then
% used to inpaint the target region. $\alpha$-trimming removes the effects
% of outliers from biasing the mean.
% 
% <<alpha_trimmed_filter copy.png>>
%
% 
%% Reproduction of Results
% * Data Source Preparation
% * Algorithm Implementation
% * Parameter Optimization
%
%% Reproduction of Results: Data Source Preparation
%
% All reproduction efforts were performed on 8-bit grayscale images. To
% replicate the methodology presented in "Image Inpainting Using Nonlocal
% Texture Matching and Nonlinear Filtering" by Ding et al., the image from
% Figure 14 of their paper was selected:
%
% <<full_image2.gif>>
%
% All zero-valued pixels in the original image from Fig. 14(a) were set to
% 1. Recall that an 8-bit image is being used, so a value of 1 is very
% close to complete blackness. The mask from Fig. 14(b) was isolated and
% applied to the original image. The copying of the mask was not perfect and some manual
% tailoring of individual pixels was performed to ensure that the mask
% covers the entirety of the region intended for inpainting. All non-zero
% regions of the mask were used to set the original image to 0, thus
% dividing the image into a source region (non-zero values) and a missing
% region (zero-values). The input was then downsampled to relieve
% computational demand.
% Looking at the figure below: the top-left image is the original image;
% the top-right image is the mask (the white region is used to define the
% missing region); the bottom-left image is downsampled original image
% after application of the mask; the bottom-right image is the inpainted
% image.
% 
% <<man_quad copy.PNG>>
% 
%  The code used for preparing the input image, image_prep.m, is presented below.
% 
% <include>image_prep.m</include>
% 
%% Reproduction of Results: Algorithm Implementation
% 
% The algorithm was implemented as described in the Proposed Solution
% section of this report. A main function, main.m, is used to call all
% necessary functions.
% 
% <include>main.m</include>
% 
% The critical functions called by main.m are:
%
% * image_prep.m
% * find_target_patch.m
% * find_can_patches.m
% * inpaint_target.m
% 
% The first function call after image_prep.m (which has already been
% described in the Data Source Preparation section of this report) is
% find_target_patch.m. As expected, it computes the target patch by
% maximizing the priority function. It is shown below.
% 
% <include>find_target_patch.m</include>
%
% The next function call is for find_can_patches.m. It uses the output of
% find_target_patch.m to locate the $\lambda$ most suitable candidate
% regions. The NLTS measure is used for this assessment. This code is shown
% below.
% 
% <include>find_can_patches.m</include>
% 
% The first iteration is depicted below. The target region is indicated by
% the red square and the 5 candidate regions with highest NLTS measure are
% indicated by the blue squares.
% 
% <<candidates copy.png>>
% 
% Once the target and candidate patches have been determined, inpaint_target.m applies the
% $\alpha$-trimmed mean filter is used to extract the average values of the
% candidate patches, which are then used to inpaint and fill the missing
% region. The code for inpaint_target.m is below.
% 
% <include>inpaint_target.m</include>
% 
% Below is the progression of inpainting in gif format. Note that the gif
% updates every 2 seconds but will not repeat once it has completed its
% loop. If the reader desires to restart the gif, please refresh the page
% and scroll to this section. These results are for _m_ = 11, $\lambda$ =
% 5, $\alpha$ = 0.2, and $\sigma$ = 1.5.
% 
% <<iterations_2.gif>>
%
%% Reproduction of Results: Parameter Optimization
% 
% There are multiple parameters that may be adjusted, and this report
% focuses on _m_ - the edge-length of the target and candidate patches -
% and $\lambda$ - the number of images used for the $\alpha$-trimmed mean
% filter. Altering _m_ has a large effect on the output. As the magnitude
% of m increases, inpainting occurs more rapidly because more pixels are
% inpainted in every iteration, but the more poorly-suited the candidate
% regions are. The number of iterations required scales loosely with the
% inverse of $m^2$.
% 
% <<m_comp copy.png>>
% 
% <html>
% <table border=1><tr><td><b>m</b></td><td><b>Number of iterations</b></td><td><b>Run Time (s)</b></td></tr>
% <tr><td>5</td><td>392</td><td>95.6</td></tr>
% <tr><td>9</td><td>111</td><td>22.4</td></tr>
% <tr><td>13</td><td>57</td><td>10.7</td></tr>
% <tr><td>17</td><td>35</td><td>6.4</td></tr></table>
% </html>
% 
% Adjusting $\lambda$ has a much smaller effect on the result, both in
% terms of a qualitative assessment of inpainting performance as well as in
% terms of computational time.
% 
% <<l_comp copy.png>>
% 
% <html>
% <table border=1><tr><td><b>&lambda;</b></td><td><b>Number of iterations</b></td><td><b>Run Time (s)</b></td></tr>
% <tr><td>5</td><td>111</td><td>22.7</td></tr>
% <tr><td>9</td><td>115</td><td>23.7</td></tr>
% <tr><td>13</td><td>118</td><td>25.2</td></tr>
% <tr><td>17</td><td>119</td><td>25.9</td></tr></table>
% </html>
%
%% Extension to Other Images
% 
% To extend beyond the results presented by Ding et al., a landscape photo
% was selected (top-left image). The tree in the photo was selected for
% removal by manually colouring all pixels to be removed as pure white. The
% white pixels were then selected to be the mask (top-right image) and the
% same procedures were followed as for the paper replication. The
% bottom-left image depicts the mask applied to a down-sampled version of
% the original image, and the bottom-right image is the result of image
% inpainting using _m_ = 11, $\lambda$ = 5, $\alpha$ = 0.2, and $\sigma$ =
% 2.0. Empirically, $\sigma$ = 2.0 produced better results than $\sigma$ =
% 1.5 for this particular input image.
% 
% <<tree_quad_good copy.png>>
% 
% The tree was able to be successfully removed from the image. The below
% gif shows the inpainting following each iteration. To view the gif from
% the beginning, please refresh the page and scroll.
% 
% <<iterations_2_tree.gif>>
%
%% Analysis and Conclusions
% 
% The method proposed by Ding et al. was properly replicated and image
% inpainting was successfully achieved. Although a ghost of the removed
% object is observable in the inpainted images, it is possible to tune the
% algorithm parameters to minimize these irregularities. In particular, the
% size _m_ of the target and candidate regions has the largest effect on
% both the quality of the inpainting, which was assessed qualitatively
% based on the presence of a ghost, as well as on the time required for the
% code to execute. Lower _m_'s result in greater inpainting quality but
% require more iterations to converge.
% 
% To quantitatively assess the optimal parameters, Ding et al. use peak
% signal to noise ratio and a structual similarity metric. To continue
% beyond the current reproduction efforts, a next step for the authors of
% this report would be to optimize the trade-off between image quality and
% algorithm speed by tuning the parameter _m_ appropriately. Furthermore,
% the parameters $\sigma$ and _h_ for candidate patch selection could be
% tuned to observe whether their optimal values match those reported by
% Ding et al. Overall, the novel inpainting method of a NLTS measure with
% pixel-wise intensity smoothing has been reproduced, tested, and
% validated.
%
%% Source Files
% 
% Main function:
% <../main.m>
% 
% Prepare image for paper reproduction:
% <../image_prep.m>
% 
% Prepare image of tree:
% <../image_prep2.m>
% 
% Locate target patch:
% <../find_target_patch.m>
% 
% Locate candidates patches:
% <../find_can_patches.m>
% 
% Inpaint target patch using candidate patches:
% <../inpaint_target.m>
% 
% Visualization of progress following each iteration:
% <../progress_update.m>
% 
% Create gif to visualize progress:
% <../create_gif.m>
% 